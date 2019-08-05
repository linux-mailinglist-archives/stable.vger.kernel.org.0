Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C826181938
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 14:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728028AbfHEMZs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 08:25:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:58692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727259AbfHEMZr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 08:25:47 -0400
Received: from pobox.suse.cz (prg-ext-pat.suse.com [213.151.95.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 399262086D;
        Mon,  5 Aug 2019 12:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565007947;
        bh=z/rXzK3fVSHKaQ3W0t1WANwveIskt8hBss5bKhDSdXU=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=fwW/JW4PPdK344AWUoKB45NQ9nRSps6rs2winulERO1bBadTWAdHDyQdnTWGpssqB
         Es0BExOYPXj/I+pdmQAGQsL9nVxOndPCX4I0e020w01ONpp/gRKXCKeEC0PLbdWdQB
         ojwmXi+nL2h37vsFm91aD1IGh7f0BS44ja0KJwhE=
Date:   Mon, 5 Aug 2019 14:25:43 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Sebastian Parschauer <s.parschauer@gmx.de>
cc:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] HID: Add quirk for HP X1200 PIXART OEM mouse
In-Reply-To: <20190724184003.12402-1-s.parschauer@gmx.de>
Message-ID: <nycvar.YFH.7.76.1908051425350.5899@cbobk.fhfr.pm>
References: <20190724184003.12402-1-s.parschauer@gmx.de>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 24 Jul 2019, Sebastian Parschauer wrote:

> The PixArt OEM mice are known for disconnecting every minute in
> runlevel 1 or 3 if they are not always polled. So add quirk
> ALWAYS_POLL for this one as well.
> 
> Jonathan Teh (@jonathan-teh) reported and tested the quirk.
> Reference: https://github.com/sriemer/fix-linux-mouse/issues/15
> 
> Signed-off-by: Sebastian Parschauer <s.parschauer@gmx.de>
> CC: stable@vger.kernel.org

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs

