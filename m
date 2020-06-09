Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1061D1F3808
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 12:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbgFIKZp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 06:25:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:56972 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728760AbgFIKZi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 06:25:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A55D0ABCF;
        Tue,  9 Jun 2020 10:25:36 +0000 (UTC)
Message-ID: <1591698316.26484.1.camel@suse.de>
Subject: Re: [PATCH] cdc-acm: Add DISABLE_ECHO quirk for Microchip/SMSC chip
From:   Oliver Neukum <oneukum@suse.de>
To:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Date:   Tue, 09 Jun 2020 12:25:16 +0200
In-Reply-To: <20200605105418.22263-1-joakim.tjernlund@infinera.com>
References: <20200605105418.22263-1-joakim.tjernlund@infinera.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Dienstag, den 09.06.2020, 09:18 +0000 schrieb Joakim Tjernlund:
> USB_DEVICE(0x0424, 0x274e) can send data before cdc_acm is ready,
> causing garbage chars on the TTY causing stray input to the shell
> and/or login prompt.
> 
> Signed-off-by: Joakim Tjernlund <joakim.tjernlund@infinera.com>
> Cc: stable@vger.kernel.org
Acked-by: Oliver Neukum <oneukum@suse.com>
