Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 891A34C9732
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 21:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238380AbiCAUoY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 15:44:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238370AbiCAUoX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 15:44:23 -0500
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AA1EC55489;
        Tue,  1 Mar 2022 12:43:42 -0800 (PST)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id C067392009D; Tue,  1 Mar 2022 21:43:39 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id BA7E692009B;
        Tue,  1 Mar 2022 20:43:39 +0000 (GMT)
Date:   Tue, 1 Mar 2022 20:43:39 +0000 (GMT)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Bjorn Helgaas <bhelgaas@google.com>
cc:     linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PING^2][PATCH v2] PCI: Sanitise firmware BAR assignments behind a
 PCI-PCI bridge
In-Reply-To: <alpine.DEB.2.21.2202010150100.58572@angie.orcam.me.uk>
Message-ID: <alpine.DEB.2.21.2203011740550.11354@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2202010150100.58572@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 1 Feb 2022, Maciej W. Rozycki wrote:

> Fix an issue with the Tyan Tomcat IV S1564D system, the BIOS of which 
> does not assign PCI buses beyond #2, where our resource reallocation 
> code preserves the reset default of an I/O BAR assignment outside its 
> upstream PCI-to-PCI bridge's I/O forwarding range for device 06:08.0 in 
> this log:

 Ping for:
<https://lore.kernel.org/all/alpine.DEB.2.21.2202010150100.58572@angie.orcam.me.uk/>

  Maciej

