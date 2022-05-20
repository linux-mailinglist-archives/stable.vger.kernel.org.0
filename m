Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 615AF52E9E1
	for <lists+stable@lfdr.de>; Fri, 20 May 2022 12:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236301AbiETKa0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 May 2022 06:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233724AbiETKaZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 May 2022 06:30:25 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C86E8BD0F
        for <stable@vger.kernel.org>; Fri, 20 May 2022 03:30:24 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id D0CA522A; Fri, 20 May 2022 12:30:22 +0200 (CEST)
Date:   Fri, 20 May 2022 12:30:21 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     =?iso-8859-1?Q?J=F6rg-Volker?= Peetz <jvpeetz@web.de>
Cc:     SuraveeSuthikulpanit <suravee.suthikulpanit@amd.com>,
        vasant.hegde@amd.com, WillDeacon <will@kernel.org>,
        stable@vger.kernel.org
Subject: Re: Linux 5.17.5
Message-ID: <YodtvQJXInHDI3lD@8bytes.org>
References: <165106510338255@kroah.com>
 <a5c7406e-64b0-7522-fef0-27fec1ac6698@web.de>
 <Ym+oOjFrkdju5H6X@8bytes.org>
 <4bfd2811-69ec-e4ec-2957-7054a075aa50@web.de>
 <YnI2QYZ1GqmORC10@8bytes.org>
 <f731aff4-a20a-26b3-473f-723b65e760ce@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f731aff4-a20a-26b3-473f-723b65e760ce@web.de>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jörg,

On Wed, May 04, 2022 at 03:21:45PM +0200, Jörg-Volker Peetz wrote:
> now with the really patched kernel 5.17.5 the warning doesn't show up anymore. I
> did two cold starts and one reboot.
> 
> There are only two warnings regarding the CPU:
> 
> [    2.659141] amdgpu 0000:30:00.0: amdgpu: PSP runtime database doesn't exist
> [    3.538925] amdgpu: SRAT table not found
> 
> Sorry for the confusion and many thanks for your help.

I just sent out a fix increasing the loop timeout, can you please test
it and report whether it also make the message disappear on your
machine?

Thanks,
	
	Jörg
