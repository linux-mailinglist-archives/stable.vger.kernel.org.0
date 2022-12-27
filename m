Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7B55656884
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 09:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbiL0InO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 03:43:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiL0InN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 03:43:13 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2074EBC;
        Tue, 27 Dec 2022 00:43:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672130592; x=1703666592;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=H0hXQ/Z3etzaKizlZHQPEm8Z38MTZW7VvRX+YtwOEX4=;
  b=MwwU7ReFFHsmF0aq2kyb6EOLT4/UAY4dUgq/4HipER4bv95mwHRXtQCo
   1Bgc3zUNIBlXb7lJm8v5CPFqr3F8VnRoQsMhZ1Vr6TsOHpn/mejDX1/eY
   ZK6r1KAyUUprNr1ai+0WLpZrCggd9a96FpQGg8G6urRDJ4xIp68luBdG9
   byWUiQvSj9w77XVE2fh/CWa2G28g5NFryhr1UFbwmW30o8NcVk5HDq6le
   FnB8s3wfYyTDSDlXP9unGwuMyVIIdqG4vGhNHXTO6Z7QDW08aBmryk3MM
   AIAAzgk2klvYKnylwxpGjZkte1pzkwpn4pX9rnR8cyEZmn2psIP7ASIFP
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10572"; a="320754119"
X-IronPort-AV: E=Sophos;i="5.96,278,1665471600"; 
   d="scan'208";a="320754119"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Dec 2022 00:43:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10572"; a="827070119"
X-IronPort-AV: E=Sophos;i="5.96,278,1665471600"; 
   d="scan'208";a="827070119"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga005.jf.intel.com with ESMTP; 27 Dec 2022 00:43:08 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id E92E3159; Tue, 27 Dec 2022 10:43:40 +0200 (EET)
Date:   Tue, 27 Dec 2022 10:43:40 +0200
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Utkarsh Patel <utkarsh.h.patel@intel.com>
Cc:     michael.jamet@intel.com, andreas.noever@gmail.com,
        YehezkelShB@gmail.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, rajmohan.mani@intel.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] thunderbolt: Do not report errors if on-board
 retimers are found
Message-ID: <Y6qwPMd87QQN9ZcC@black.fi.intel.com>
References: <20221223042246.3355450-1-utkarsh.h.patel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221223042246.3355450-1-utkarsh.h.patel@intel.com>
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 22, 2022 at 08:22:46PM -0800, Utkarsh Patel wrote:
> tb_retimer_scan() returns error even when on-board retimers are found.
> 
> Fixes: 1e56c88adecc ("thunderbolt: Runtime resume USB4 port when retimers are scanned")
> Cc: stable@vger.kernel.org
> Signed-off-by: Utkarsh Patel <utkarsh.h.patel@intel.com>

Applied now, thanks!
