Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA6D32FBBB4
	for <lists+stable@lfdr.de>; Tue, 19 Jan 2021 16:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391424AbhASPxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 10:53:20 -0500
Received: from netrider.rowland.org ([192.131.102.5]:36341 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S2391411AbhASPwe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jan 2021 10:52:34 -0500
Received: (qmail 175159 invoked by uid 1000); 19 Jan 2021 10:51:45 -0500
Date:   Tue, 19 Jan 2021 10:51:45 -0500
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Greg KH <greg@kroah.com>
Cc:     Hamish Martin <Hamish.Martin@alliedtelesis.co.nz>,
        "paul.kocialkowski@bootlin.com" <paul.kocialkowski@bootlin.com>,
        stable@vger.kernel.org,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Request to apply commit c4005a8f65ed to the -stable kernels
Message-ID: <20210119155145.GB173923@rowland.harvard.edu>
References: <20200910212512.16670-1-hamish.martin@alliedtelesis.co.nz>
 <X+huemxT9XOeDi5E@aptenodytes>
 <20210109212608.GB1136657@rowland.harvard.edu>
 <83ed9f3929bd064b54bb9903cd489adde442e1c7.camel@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83ed9f3929bd064b54bb9903cd489adde442e1c7.camel@alliedtelesis.co.nz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg:

Hamish Martin has reported a problem caused by applying commit 
b77d2a0a223b ("usb: ohci: Default to per-port over-current protection") 
to the -stable kernel series without also applying commit c4005a8f65ed 
("usb: ohci: Make distrust_firmware param default to false").

Can we please queue up commit c4005a8f65ed for all the -stable kernel 
branches which already merged versions of commit b77d2a0a223b?

Thanks,

Alan Stern
