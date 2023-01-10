Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46EE266453E
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 16:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbjAJPsF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 10:48:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233555AbjAJPsE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 10:48:04 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD17844C51
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 07:48:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 29530CE1822
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 15:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8778AC433EF;
        Tue, 10 Jan 2023 15:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673365678;
        bh=ss5sVhJFDTAZPEGENJGtCF6+R9cZQ+huXnZOvLeLg8s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bL8kTXToFFr/8UpbYLZxNlHIukI78Ewb5zGcDzlJOlAh/hvJlPs38ivlK3rPq7TUa
         McM1ePhpmHJSIFIUWuKybQIc+T2U19mXu0KTRpZUjN67H8NHC7RBI4hwTtza2S2qeq
         IorTKqKVOvhLnPjLy7x5726+xKHcP9p6MrjcPVfQ=
Date:   Tue, 10 Jan 2023 16:47:49 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     stable@vger.kernel.org, matthieu.baerts@tessares.net,
        pabeni@redhat.com, mptcp@lists.linux.dev
Subject: Re: [PATCH 5.15 0/2] mptcp: use proper req destructor for IPv6
Message-ID: <Y72IpXaOMXJKqoje@kroah.com>
References: <20230107011959.448249-1-mathew.j.martineau@linux.intel.com>
 <eac12f5d-303a-8318-cc75-4e0870174a9d@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eac12f5d-303a-8318-cc75-4e0870174a9d@linux.intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 06, 2023 at 05:53:48PM -0800, Mat Martineau wrote:
> On Fri, 6 Jan 2023, Mat Martineau wrote:
> 
> > Greg -
> > 
> > Here are backports of two MPTCP patches that recently failed to apply to
> > the 5.15 stable tree. Two prerequisite patches are already queued in
> > 5.15.87-rc1:
> > 
> >  mptcp: mark ops structures as ro_after_init
> >  mptcp: remove MPTCP 'ifdef' in TCP SYN cookies
> > 
> > These patches prevent IPv6 memory leaks with MPTCP.
> > 
> 
> Sorry about the cut & paste error on the cover letter subject line, was
> supposed to be "v5.15 stable backports for MPTCP request sock fixes".

No worries, all now queued up.

greg k-h
