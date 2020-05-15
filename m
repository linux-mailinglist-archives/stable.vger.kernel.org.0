Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39CC31D4D39
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 14:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbgEOMA1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 May 2020 08:00:27 -0400
Received: from lizzard.sbs.de ([194.138.37.39]:49485 "EHLO lizzard.sbs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726062AbgEOMA1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 May 2020 08:00:27 -0400
X-Greylist: delayed 960 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 May 2020 08:00:27 EDT
Received: from mail1.sbs.de (mail1.sbs.de [192.129.41.35])
        by lizzard.sbs.de (8.15.2/8.15.2) with ESMTPS id 04FBiLWV020479
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 May 2020 13:44:21 +0200
Received: from md1za8fc.ad001.siemens.net ([167.87.8.125])
        by mail1.sbs.de (8.15.2/8.15.2) with ESMTP id 04FBiLmf028834;
        Fri, 15 May 2020 13:44:21 +0200
Date:   Fri, 15 May 2020 13:44:20 +0200
From:   Henning Schild <henning.schild@siemens.com>
To:     stable@vger.kernel.org
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: backport of cifs patch to 4.4.x and 4.9.x
Message-ID: <20200515134420.50480bb7@md1za8fc.ad001.siemens.net>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

please backport the following path to 4.4.x and 4.9.x

subject: cifs: Fix a race condition with cifs_echo_request
hash: f2caf901c1b7ce65f9e6aef4217e3241039db768

regards,
Henning
