Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E555E4A8A9F
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 18:48:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236035AbiBCRss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 12:48:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54598 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232884AbiBCRss (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 12:48:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8130617B4
        for <stable@vger.kernel.org>; Thu,  3 Feb 2022 17:48:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95BC4C340E8;
        Thu,  3 Feb 2022 17:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643910527;
        bh=SfktYwOcwd+4znhKsdIt/+Hz0Iapun1I4sRMZJRBi5o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0SPit3zCT6hnVd2do9DSUcL9gpW+G0hFXdKgFn3IPWQVozR4/mo+ZgQMiCuePKEEQ
         1mex4WpoCJ6V8SO0WVqtGSAmlJibQjgALr/Gxb8BdqO3WbOVNLwwKVALYTuUQo3GOE
         KfPJNoxMUkI0Izg89FGTyL9RJZ8y1YZPrLIPgJL4=
Date:   Thu, 3 Feb 2022 18:48:43 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Namhyung Kim <namhyung@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        "stable # 4 . 5" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] perf/core: Fix cgroup event list
 management" failed to apply to 5.10-stable tree
Message-ID: <YfwVe/wqxyEDETCr@kroah.com>
References: <164361730315712@kroah.com>
 <CAM9d7cgm1QRscxxtapdHZxzpVTfbwY91xHkDq5Vy-30N6mzXWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM9d7cgm1QRscxxtapdHZxzpVTfbwY91xHkDq5Vy-30N6mzXWw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 31, 2022 at 12:41:26PM -0800, Namhyung Kim wrote:
> Hi Greg,
> 
> On Mon, Jan 31, 2022 at 12:29 AM <gregkh@linuxfoundation.org> wrote:
> >
> >
> > The patch below does not apply to the 5.10-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> I think it fails because the dependent commit ef54c1a476ae ("perf:
> Rework perf_event_exit_event()") was reverted already (because
> of the issue this commit fixes).
> 
> Could you please try it again with the above commit?  If it still doesn't
> work, please let me know.

Yes, that seemed to work, thanks!

greg k-h
