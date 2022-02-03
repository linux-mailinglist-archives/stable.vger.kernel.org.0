Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D283E4A8930
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 18:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241209AbiBCRBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 12:01:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiBCRBM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 12:01:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B308C061714
        for <stable@vger.kernel.org>; Thu,  3 Feb 2022 09:01:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 672AEB834DA
        for <stable@vger.kernel.org>; Thu,  3 Feb 2022 17:01:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F41C340ED;
        Thu,  3 Feb 2022 17:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643907669;
        bh=9fFB0CMENBraK7wSLd+mdQE6aUtMo+udZGW/qpjXSPk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ldr5SqAsUYJEXoTqJH8I/OZCX8zioAf5tvVuJdAo+4OtuxDrl5qn1Jpay8ijPQPr8
         oDF6QwhzMi2lTLNY6HY5KMsSG3cOzpORcJEhzbBmFZHmtWYFPhVJD5rh+Ftb2frwg/
         lbDKcxiGAGEYI2XVXWjEX68nrCsFyoUEDc88VgyU=
Date:   Thu, 3 Feb 2022 18:01:06 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alessio Balsini <balsini@android.com>
Cc:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        stable@vger.kernel.org, lee.jones@linaro.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH 4.14] bpf: fix truncated jump targets on heavy expansions
Message-ID: <YfwKUsZ93EQfDYQH@kroah.com>
References: <20220201170544.293476-1-balsini@android.com>
 <YfmHThlq0pv2TOjf@mussarela>
 <Yfp8DeOdtlyEGG1W@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yfp8DeOdtlyEGG1W@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 02, 2022 at 12:41:49PM +0000, Alessio Balsini wrote:
> Hi Thadeu,
> 
> On Tue, Feb 01, 2022 at 04:17:34PM -0300, Thadeu Lima de Souza Cascardo wrote:
> > 
> > Hi, Alessio.
> > 
> > This matches the backport I had prepared, but didn't manage to submit in time.
> > 
> > Thanks.
> > Acked-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> > 
> 
> Argh! I wish I spotted your backport in the Ubuntu kernel patchworks
> earlier. :)
> I tested this change with LTP's bpf_map01 and bpf_prog[1-4].
> Can we consider this ready for being queued up?

Looks good, now queued up, thanks.

greg k-h
