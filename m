Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63D43AA32C
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 14:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389417AbfIEM2D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 08:28:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:56630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732410AbfIEM2C (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Sep 2019 08:28:02 -0400
Received: from pobox.suse.cz (prg-ext-pat.suse.com [213.151.95.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 054702080C;
        Thu,  5 Sep 2019 12:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567686482;
        bh=9S8tbDmcX+m0zl7AzUPbkOfWRsK1GjMnTM3Jp8xy6CE=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=zVB9O6BtryQTG7F070qsr9dZR4XmcpWEilYYWFKgrzrsJP9xuiU/AiVfWDFBxE3zq
         XlEIcgh+gbIIe2YC3OotZds0To09TFY6nDA4Wfii1JhQjbv6sNcaBLGYmjMdntTOBj
         kOIEsZXlsIIY044aETvJeenNeWsjGQKjVqofTdDc=
Date:   Thu, 5 Sep 2019 14:27:45 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Roderick Colenbrander <roderick@gaikai.com>
cc:     linux-input@vger.kernel.org, andreyknvl@google.com,
        Roderick Colenbrander <roderick.colenbrander@sony.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] HID: sony: Fix memory corruption issue on cleanup.
In-Reply-To: <20190904212211.29832-1-roderick@gaikai.com>
Message-ID: <nycvar.YFH.7.76.1909051427340.31470@cbobk.fhfr.pm>
References: <20190904212211.29832-1-roderick@gaikai.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 4 Sep 2019, Roderick Colenbrander wrote:

> From: Roderick Colenbrander <roderick.colenbrander@sony.com>
> 
> The sony driver is not properly cleaning up from potential failures in
> sony_input_configured. Currently it calls hid_hw_stop, while hid_connect
> is still running. This is not a good idea, instead hid_hw_stop should
> be moved to sony_probe. Similar changes were recently made to Logitech
> drivers, which were also doing improper cleanup.
> 
> Signed-off-by: Roderick Colenbrander <roderick.colenbrander@sony.com>
> CC: stable@vger.kernel.org

Applied, thanks Roderick.

-- 
Jiri Kosina
SUSE Labs

