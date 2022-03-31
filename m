Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26A694ED487
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 09:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbiCaHNm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 03:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbiCaHNN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 03:13:13 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8E9C144A38;
        Thu, 31 Mar 2022 00:11:20 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id E707F92009E; Thu, 31 Mar 2022 09:11:19 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id E08BE92009C;
        Thu, 31 Mar 2022 08:11:19 +0100 (BST)
Date:   Thu, 31 Mar 2022 08:11:19 +0100 (BST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Bjorn Helgaas <helgaas@kernel.org>
cc:     Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PING^3][PATCH v2] PCI: Sanitise firmware BAR assignments behind a
 PCI-PCI bridge
In-Reply-To: <alpine.DEB.2.21.2203012338460.46819@angie.orcam.me.uk>
Message-ID: <alpine.DEB.2.21.2203310031210.44113@angie.orcam.me.uk>
References: <20220301231547.GA663097@bhelgaas> <alpine.DEB.2.21.2203012338460.46819@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2 Mar 2022, Maciej W. Rozycki wrote:

> > > Fix an issue with the Tyan Tomcat IV S1564D system, the BIOS of which 
> > > does not assign PCI buses beyond #2, where our resource reallocation 
> > > code preserves the reset default of an I/O BAR assignment outside its 
> > > upstream PCI-to-PCI bridge's I/O forwarding range for device 06:08.0 in 
> > > this log:
> > 
> > Would you mind collecting the complete dmesg log before your patch?
> > It's hard to get the entire picture from snippets.
> 
>  Sure, here's the original log from at the time when I made the patch.  I 
> think it's as verbose as you can get; there's no way I could have used it 
> for the change description.
> 
>  Also I doubt it should matter, but if you need a fresh log instead from 
> 5.17, then I can make one too, but that will take a bit.  Let me know if 
> you need me to try anything else too.

 Ping for:
<https://lore.kernel.org/all/alpine.DEB.2.21.2202010150100.58572@angie.orcam.me.uk/>

Do you need any further information?

  Maciej
