Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD3C859E4CE
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 16:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241957AbiHWOEP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 10:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244843AbiHWOCh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 10:02:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E065C243BAD;
        Tue, 23 Aug 2022 04:11:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CC9461598;
        Tue, 23 Aug 2022 11:10:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 330A6C433D6;
        Tue, 23 Aug 2022 11:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661253048;
        bh=Ej2f/4SpSbdrp05Uz+VxdpFfI9gh8J1Jjq0tLjxbmaQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j8QWfzI/dkSetVrmDfn95WQZXErTwU5c+cA4e/WPgqDc19snvHoNt7GHVoSFvlfPb
         aMC5luBPN/JT7cOxQWhow7bffkN8qeTIKteNFTntXjPk4eeCFehC01/10AGecxPfJi
         SkiOcmjOItpJzWlA8OS5iVOqcZciLsUrUh6Ar3sc=
Date:   Tue, 23 Aug 2022 13:10:44 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Conor.Dooley@microchip.com
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Brice.Goglin@inria.fr, palmer@rivosinc.com, sashal@kernel.org
Subject: Re: [PATCH 5.19 332/365] riscv: dts: sifive: Add fu540 topology
 information
Message-ID: <YwS1tCGsk/N0D18r@kroah.com>
References: <20220823080118.128342613@linuxfoundation.org>
 <20220823080132.111184627@linuxfoundation.org>
 <b92e80fc-c8f5-0a19-44ff-f08e2674b7cc@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b92e80fc-c8f5-0a19-44ff-f08e2674b7cc@microchip.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 23, 2022 at 09:49:35AM +0000, Conor.Dooley@microchip.com wrote:
> On 23/08/2022 09:03, Greg Kroah-Hartman wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > 
> > From: Conor Dooley <conor.dooley@microchip.com>
> > 
> > [ Upstream commit af8f260abc608c06e4466a282b53f1e2dc09f042 ]
> > 
> > The fu540 has no cpu-map node, so tools like hwloc cannot correctly
> > parse the topology. Add the node using the existing node labels.
> > 
> > Reported-by: Brice Goglin <Brice.Goglin@inria.fr>
> > Link: https://github.com/open-mpi/hwloc/issues/536
> > Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
> > Link: https://lore.kernel.org/r/20220705190435.1790466-3-mail@conchuod.ie
> > Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> Hey Greg,
> I pointed out on the AUTOSEL'd version of these patches that
> adding the optional dt property papers over the problem rather than
> really fixing it & Sudeep suggested the time that these patches were
> not stable worthy, hence the lack of a CC: stable.
> 
> The following has been merged into riscv/for-next & is pending for
> arm64/driver core as an actual fix for RISC-V's default topology
> reporting:
> https://lore.kernel.org/linux-riscv/4849490e-b362-c13a-c2e4-82acc3268a3f@microchip.com/#t
> 
> As I said to Sasha, I defer to your (plural) better judgement here,
> but just so that you're aware of the context.

Thanks for letting me know, I've now dropped it from all stable release
queues.

greg k-h
