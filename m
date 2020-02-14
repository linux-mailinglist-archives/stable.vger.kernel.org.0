Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A61B15D534
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 11:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbgBNKHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 05:07:01 -0500
Received: from mx1.riseup.net ([198.252.153.129]:55092 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729007AbgBNKHB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 05:07:01 -0500
Received: from capuchin.riseup.net (unknown [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 48JpvT023gzFbgN;
        Fri, 14 Feb 2020 02:07:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1581674821; bh=EpP/VOuCM32VikvygZs6oHlBoPImlhqCa6JkX4jEmZk=;
        h=Date:From:To:Cc:Subject:From;
        b=SJtoVvTxrg8NGtaXO0sSRFtRt4+oM+AGFDYPmWW103q0W+SNbyZ6Mqx3woh18v+Ur
         pOB19aahJIX0vNU+a2y++YXolYG8YIKqPzEbKO/iii/oMmG5geuuszOa8+IU964DBw
         FfpxPZzy4Tbnu1d8byYIuH/sJJ60TbFK/A2l0dAw=
X-Riseup-User-ID: 2F87842273C5F1A09B69FC82CA65425F1D23DD6D3DA2793674F0C0BD7842B8B9
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 48JpvR4KW8z8sXD;
        Fri, 14 Feb 2020 02:06:59 -0800 (PST)
Date:   Fri, 14 Feb 2020 10:06:55 +0000
From:   cipher-hearts@riseup.net
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: 4.14+ doesn't work on only board with open-source BIOS & without
 Spectre bugs
Message-ID: <20200214100655.pyljxoa5pkhagbct@localhost.0.0.1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


https://bugzilla.kernel.org/show_bug.cgi?id=206257

Any suggestions?
