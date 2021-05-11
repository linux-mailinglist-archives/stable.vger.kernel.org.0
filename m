Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1307537ABA5
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 18:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbhEKQRY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 12:17:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:34160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231769AbhEKQRY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 May 2021 12:17:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D966A6134F;
        Tue, 11 May 2021 16:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620749777;
        bh=WKboN5evuSkbIa8IBQmQjjezu9qk3Og0JoE0rDF71P0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ILccT0C/E6l1D5jybxoLvqTCv36diWsY9uS7ye6jTnaXGymhqeZvaHWphZRygmkqU
         j6x0A6WY5WDRCKLvL0b/Bl6IhhphaG9V3NdhHGtmWIoEfvlip8URt1j29B88GLlfWw
         mG8G1+xjdhTu5cGgvv6ypyH3a4b3Ls1gtlJajh2KTMH1F2okS/TR3QKQ4RH6iFb/Z2
         UYr357dDCZsXf+KWgDRY0m0rv6/3Qib6b6JRDbwj8t7ik25PKMJ5qmNLw72Bm3GcvI
         HIx8jEwfTxkgFR2ZmwOUk9hXfPPy0+Mgi+pTSlOfcMHIpye4cP6hLJ/ZNYsZ/fUt5z
         JcG4DEjmJ8HOg==
Date:   Tue, 11 May 2021 18:16:12 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Bjorn Helgaas <helgaas@kernel.org>, linux-pci@vger.kernel.org
Cc:     =?UTF-8?B?UsO2dHRp?= 
        <espressobinboardarmbiantempmailaddress@posteo.de>,
        Pali =?UTF-8?B?Um9ow6Fy?= <pali@kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] PCI: Add Max Payload Size quirk for ASMedia ASM1062
 SATA controller
Message-ID: <20210511181612.1d017bb7@thinkpad>
In-Reply-To: <20210317115924.31885-1-kabel@kernel.org>
References: <20210317115924.31885-1-kabel@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ping? :)

Marek
