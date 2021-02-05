Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53983311453
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232859AbhBEWDx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:03:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:44986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232858AbhBEOyx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:54:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9427650D5;
        Fri,  5 Feb 2021 14:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612535323;
        bh=w7uNepnjk8cvyYp0+Ic0bNCjKvJLaLsdGLsVHYG6/x8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gfy0gtsT7ImufJXtIJxqSJyNj1qeZf45G7CyjjagLtj77mio5L6UrjXXBMpuHBFOs
         BwdXtCN/6LMG4LWw2fHHCsssmKAh9rzR/QmN+Z/i+VP2jsXkZi8UFrdMnKjRHHYn1o
         IWxJco5euLaZgDmvUGb4tORcJnyyV7my0XYWtRNk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.4.256
Date:   Fri,  5 Feb 2021 15:26:37 +0100
Message-Id: <161253419611579@kroah.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <1612534196241236@kroah.com>
References: <1612534196241236@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index b18b61e540e9..0057587d2cbe 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION = 4
 PATCHLEVEL = 4
-SUBLEVEL = 255
+SUBLEVEL = 256
 EXTRAVERSION =
 NAME = Blurry Fish Butt
 
