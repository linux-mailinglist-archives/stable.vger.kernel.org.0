Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 015FB31144C
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233056AbhBEWDd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:03:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:44974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232853AbhBEOyw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:54:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D26C650AD;
        Fri,  5 Feb 2021 14:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612535317;
        bh=kNcX/dXqdzI6S0ekhUwXLPF6IHxHjQCgbpTOWAJSbKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EESPrMZdJHooPVnuG6WVWYMLkt3PjuZXOkkgqcFdRSs5kLcLSrWmp6GglM1/EsEDH
         Q2uo2yyg7ePcPxje9ddYwIyDgfLcT2rbNvGC9dYMS+S8NRX5Xj8yGcvBIvwE7aZ0XN
         prabXc6HHXYH8pR2Sw3B2CfSTq+ylHOT8gSbuC2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.9.256
Date:   Fri,  5 Feb 2021 15:26:19 +0100
Message-Id: <161253508521560@kroah.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <1612535085125226@kroah.com>
References: <1612535085125226@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 4780b5f80b2a..69af44d3dcd1 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION = 4
 PATCHLEVEL = 9
-SUBLEVEL = 255
+SUBLEVEL = 256
 EXTRAVERSION =
 NAME = Roaring Lionus
 
