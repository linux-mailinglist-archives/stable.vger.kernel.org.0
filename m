Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 184F4420323
	for <lists+stable@lfdr.de>; Sun,  3 Oct 2021 19:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbhJCRqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Oct 2021 13:46:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231317AbhJCRqs (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 3 Oct 2021 13:46:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D8C361381;
        Sun,  3 Oct 2021 17:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633283100;
        bh=eyh9mqAODjeCmSbZBxS8kSXmguOpn6A9D0SDKQfCnps=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pWdi7aZ3tc8EG85/TmejPy9cNqSZZ1PKdUceTr59yZ8lDQ/OBH56gXuVIKTbJMWof
         BAB7G8Ku2lZc0iSmcEksaW+PypHRKivI/nR9rnBPCkDRwLetWYWylqEzpJsil0iTvl
         zU/iJi+1XLj63mQ3MPBmy/8bPWXsAGXhm11+SzEWOLY3caPmmwt71dQQ9brMtiIiSj
         gLCrb5ugc+065mGPz6NJqq0JrRAOV1h9GcCnf8rLzZPDkNCpxe2qfjLOGJm2E2AJmm
         OoqFxgf8Py12dOctT9Qd6M7gRX3Z7FxJqq5sAOM1Ls/uHLbavTbypY5bFBmgZY1B+i
         /Wg3r+KVEeYMw==
Date:   Sun, 3 Oct 2021 19:44:55 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     stable@vger.kernel.org
Cc:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        pali@kernel.org
Subject: Re: [PATCH 02/13] PCI: aardvark: Fix PCIe Max Payload Size setting
Message-ID: <20211003194455.1568f654@thinkpad>
In-Reply-To: <20211001195856.10081-3-kabel@kernel.org>
References: <20211001195856.10081-1-kabel@kernel.org>
        <20211001195856.10081-3-kabel@kernel.org>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg, Sasha,

I accidentally sent these patches to stable even though they are not
merged in upstream yet (by not configuring git-send-email correctly).

Sorry about that, please ignore this series in stable for now.

Marek
