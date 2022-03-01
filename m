Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84C564C98FB
	for <lists+stable@lfdr.de>; Wed,  2 Mar 2022 00:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbiCAXQe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 18:16:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiCAXQe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 18:16:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C3D92865;
        Tue,  1 Mar 2022 15:15:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C35EB81E68;
        Tue,  1 Mar 2022 23:15:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9668DC340EE;
        Tue,  1 Mar 2022 23:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646176549;
        bh=nG8/9ukPx+kBqCowdRccQFkoae/2ciAMttrfoJY2Mqw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=uzaG3g4XGiznCh696GhzZ/Lxbe3ZJVTQ+naSpyciWzgKSao46PoohTW6Q3PVMKXNl
         iWEHVe2238dCJhlflJJcNgH9JaD3Wq4a8oaKS4drU5jg2HP2TBKJTDvJT0dTdO7gAs
         rTGj8l5WvVNdxnG6BjrMqtYr7zLPJJUoBBE8eZXFAtKRz9vK/WyWIg23JP7vhwtgRa
         0pdUXyMpuQlSdGDgvPlEifmaUrEidVhYHyxMAfxJuDjm3wsrUeDzwhxNGVviyJ6M+E
         omaO3+maqea9OYVSKXRD+tsxqskfd19pe2rkMaNexdxw3XVs47HGAQuuuDV0LEqAeA
         caH0QB6eW7vCg==
Date:   Tue, 1 Mar 2022 17:15:47 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [RESEND][PATCH v2] PCI: Sanitise firmware BAR assignments behind
 a PCI-PCI bridge
Message-ID: <20220301231547.GA663097@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2202010150100.58572@angie.orcam.me.uk>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 01, 2022 at 10:51:11AM +0000, Maciej W. Rozycki wrote:
> Fix an issue with the Tyan Tomcat IV S1564D system, the BIOS of which 
> does not assign PCI buses beyond #2, where our resource reallocation 
> code preserves the reset default of an I/O BAR assignment outside its 
> upstream PCI-to-PCI bridge's I/O forwarding range for device 06:08.0 in 
> this log:

Would you mind collecting the complete dmesg log before your patch?
It's hard to get the entire picture from snippets.

Bjorn
