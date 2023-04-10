Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBBDA6DCAC8
	for <lists+stable@lfdr.de>; Mon, 10 Apr 2023 20:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbjDJSc0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 14:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjDJScZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 14:32:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5BA41FE5;
        Mon, 10 Apr 2023 11:32:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 717B36136F;
        Mon, 10 Apr 2023 18:32:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5544EC433D2;
        Mon, 10 Apr 2023 18:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681151543;
        bh=3QWPxBcsm+oipo174o68W4BMe5Acm5YHNXM0zmTK5dY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IOjTJv4s+2i/v1OgD9PWedrYomTdBhFsysZcwp9MWSw7tTqwagiMK5Ikrh+cRNmjk
         3bMmaJPQZ8csBpw8WP9oUyuSvT+XmE7EoKPOHT80fIMbqyvKZnwH+D3n0pH4GzY0R/
         uSZZ34tUu/GnWH8osBrKGEQsH2zQS5ljkgx7StsY=
Date:   Mon, 10 Apr 2023 20:32:20 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     Bjorn Andersson <andersson@kernel.org>, bp@alien8.de,
        mchehab@kernel.org, james.morse@arm.com, rric@kernel.org,
        linux-arm-msm@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, quic_saipraka@quicinc.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v6 2/2] EDAC/qcom: Get rid of hardcoded register offsets
Message-ID: <2023041047-oboe-playmaker-ca1b@gregkh>
References: <20230314064032.16433-1-manivannan.sadhasivam@linaro.org>
 <20230314064032.16433-3-manivannan.sadhasivam@linaro.org>
 <20230315222242.hbe3z2d3c2i6psuw@ripper>
 <20230410155111.GB4630@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230410155111.GB4630@thinkpad>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 10, 2023 at 09:21:11PM +0530, Manivannan Sadhasivam wrote:
> On Wed, Mar 15, 2023 at 03:22:42PM -0700, Bjorn Andersson wrote:
> > On Tue, Mar 14, 2023 at 12:10:32PM +0530, Manivannan Sadhasivam wrote:
> > > The LLCC EDAC register offsets varies between each SoC. Hardcoding the
> > > register offsets won't work and will often result in crash due to
> > > accessing the wrong locations.
> > > 
> > > Hence, get the register offsets from the LLCC driver matching the
> > > individual SoCs.
> > > 
> > > Cc: <stable@vger.kernel.org> # 6.0: 5365cea199c7 ("soc: qcom: llcc: Rename reg_offset structs to reflect LLCC version")
> > > Cc: <stable@vger.kernel.org> # 6.0: c13d7d261e36 ("soc: qcom: llcc: Pass LLCC version based register offsets to EDAC driver")
> > > Cc: <stable@vger.kernel.org> # 6.0
> > 
> > Why is there three Cc: stable here, is this a new format for Fixes:?
> > 
> 
> This is to specify the dependencies to the stable maintainers during backport.

And that format has been documented for well over a decade in:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

This is nothing new :)

thanks,

greg k-h
