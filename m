Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4010048FBA0
	for <lists+stable@lfdr.de>; Sun, 16 Jan 2022 09:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234650AbiAPI3C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Jan 2022 03:29:02 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59122 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbiAPI3B (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Jan 2022 03:29:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BCD060DB9;
        Sun, 16 Jan 2022 08:29:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0152FC36AE7;
        Sun, 16 Jan 2022 08:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642321740;
        bh=frcCV1k9oG9oKj3dpUqdJg1PxRT2RSN/XKdLCPjaYaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0J1eIHLvaEvVZqHZiaGU4YLPmheaqPXOYwmTWOUXbKm56iV7rItVfmpQQR9uPdkNt
         OSWmjJM/7ijSUdfMBpMVu/BT4783NyKm1/fNPhgNg/ZDq8+VA37MzV0Ypolnp+WrPN
         6eFIkdPBloPgk6q+xn+Py9G2wKU3F3y59nFG2zg0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.16.1
Date:   Sun, 16 Jan 2022 09:28:51 +0100
Message-Id: <1642321730152229@kroah.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <1642321730215246@kroah.com>
References: <1642321730215246@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

