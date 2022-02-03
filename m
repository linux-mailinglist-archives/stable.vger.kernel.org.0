Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 398904A8F77
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 22:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235763AbiBCU7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:59:34 -0500
Received: from cavan.codon.org.uk ([176.126.240.207]:59828 "EHLO
        cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235108AbiBCU7e (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:59:34 -0500
Received: by cavan.codon.org.uk (Postfix, from userid 1000)
        id 1588440A55; Thu,  3 Feb 2022 20:59:33 +0000 (GMT)
Date:   Thu, 3 Feb 2022 20:59:33 +0000
From:   Matthew Garrett <mjg59@srcf.ucam.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jeremy Kerr <jk@ozlabs.org>,
        Aditya Garg <gargaditya08@live.com>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH 5.10 011/100] efi: runtime: avoid EFIv2 runtime services
 on Apple x86 machines
Message-ID: <20220203205933.GA27367@srcf.ucam.org>
References: <20220131105220.424085452@linuxfoundation.org>
 <20220131105220.835281614@linuxfoundation.org>
 <20220203205223.GA19153@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220203205223.GA19153@duo.ucw.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 03, 2022 at 09:52:23PM +0100, Pavel Machek wrote:

> This problem is not 64-bit specific, right? Should it depend on
> CONFIG_X86, instead?

Only 64-bit systems are affected (the one 32-bit generation of Apple 
hardware implementing EFI only claims 1.10 support), and 32-bit kernels 
can't make 64-bit UEFI runtime calls, so I think it's correct to make it 
64-bit only.
