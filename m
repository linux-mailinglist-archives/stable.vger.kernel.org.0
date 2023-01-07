Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34E1F660BA7
	for <lists+stable@lfdr.de>; Sat,  7 Jan 2023 02:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjAGBxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Jan 2023 20:53:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236224AbjAGBxv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Jan 2023 20:53:51 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED8078793F
        for <stable@vger.kernel.org>; Fri,  6 Jan 2023 17:53:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673056429; x=1704592429;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=tAN3tG4klx6uJOaNR1i4Z8z0U0sej1LXSMPML+feWLA=;
  b=YlWkXabFGT1VHv3QjmJZjb94ta5w590H/iHkqoHnEK77l+SJTRVU/oXy
   uMhGh40lovJNP5SHkevoN1Wfst0imCLxdJ1WPyLuMZ3qKjcTAbDwMGIAE
   HMrGw9OTacu/IonVs6+L19Sa1sHfLdgFnsb+r5RUlGjhsuigXiI76Qo1o
   +NMcga7LHI5y+3n0pwDnxs84ADJqZXxQjyW0E3eQZBy/CvkG7+jhaov/R
   hWYja3wI2UHOX4ZlbhYR9fE8yG2BOyaRRseduUmHKRVgE8ApB3vuk74ju
   LpvT5bvAZwnFcamW+2ixpz7bjz9w80W6YnZ/tWTCbZR1XjM568yOYBqy1
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="302299630"
X-IronPort-AV: E=Sophos;i="5.96,307,1665471600"; 
   d="scan'208";a="302299630"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 17:53:48 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="656115355"
X-IronPort-AV: E=Sophos;i="5.96,307,1665471600"; 
   d="scan'208";a="656115355"
Received: from rkoganti-mobl.amr.corp.intel.com ([10.209.28.230])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 17:53:48 -0800
Date:   Fri, 6 Jan 2023 17:53:48 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
cc:     matthieu.baerts@tessares.net, pabeni@redhat.com,
        mptcp@lists.linux.dev
Subject: Re: [PATCH 5.15 0/2] mptcp: use proper req destructor for IPv6
In-Reply-To: <20230107011959.448249-1-mathew.j.martineau@linux.intel.com>
Message-ID: <eac12f5d-303a-8318-cc75-4e0870174a9d@linux.intel.com>
References: <20230107011959.448249-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 6 Jan 2023, Mat Martineau wrote:

> Greg -
>
> Here are backports of two MPTCP patches that recently failed to apply to
> the 5.15 stable tree. Two prerequisite patches are already queued in
> 5.15.87-rc1:
>
>  mptcp: mark ops structures as ro_after_init
>  mptcp: remove MPTCP 'ifdef' in TCP SYN cookies
>
> These patches prevent IPv6 memory leaks with MPTCP.
>

Sorry about the cut & paste error on the cover letter subject line, was 
supposed to be "v5.15 stable backports for MPTCP request sock fixes".


--
Mat Martineau
Intel
