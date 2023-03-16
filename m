Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C16426BD5A7
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 17:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbjCPQca (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 12:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbjCPQc3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 12:32:29 -0400
Received: from mail.antaris-organics.com (mail.antaris-organics.com [91.227.220.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5AFE41CD;
        Thu, 16 Mar 2023 09:32:20 -0700 (PDT)
Date:   Thu, 16 Mar 2023 17:32:17 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mareichelt.com;
        s=202107; t=1678984337;
        bh=DjSsbRidJQY9Ol8Bts8E32QMDCvh1SCl3NdgcoKgCEA=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=BkCYUua9SK2Z8cKLOndYbECRD+IIyb1urqwRZvgCTHQ8HslVm4hv+m95EcAsNPoR+
         RLYZypCaMFexJyBRRWbCaqL22seU8t4xypnq/LjhiGLcCYzc3yYOtKNPzZ4gabueHo
         8NOfE1TX3QOLxtkR+i++3OVAPq6lrCvvrzDQP4MQAhlZTJsWrBiAojoNPjakVo2FKa
         MA/Fxu9SoodRjz3m6FCYnSk+27OR7ZFmSgx+c+gTj0tMH69SmeS++k/5juiXuvlbkA
         U2AF/9vQqyqGFsUcnbp9S5Kvy95rup0WZTuWckEPO+ROJRjUdOr6v9fQPwoV2BAsKh
         bMbzDeZzoHf0Q==
From:   Markus Reichelt <lkt+2023@mareichelt.com>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.2 000/137] 6.2.7-rc2 review
Message-ID: <20230316163217.GB3702@pc21.mareichelt.com>
Mail-Followup-To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230316083443.733397152@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316083443.733397152@linuxfoundation.org>
Organization: still stuck in reorganization mode
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.2.7 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.

Hi Greg

6.2.7-rc2

compiles, boots and runs here on x86_64
(AMD Ryzen 5 PRO 4650G, Slackware64-15.0)

Tested-by: Markus Reichelt <lkt+2023@mareichelt.com>
