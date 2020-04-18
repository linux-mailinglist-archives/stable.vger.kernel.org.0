Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD4981AEBDD
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 12:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725869AbgDRKlE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sat, 18 Apr 2020 06:41:04 -0400
Received: from gwa7.newtekwebhosting.com ([63.134.207.35]:49907 "EHLO
        GWA7.newtekwebhosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbgDRKlE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Apr 2020 06:41:04 -0400
X-Greylist: delayed 900 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Apr 2020 06:41:04 EDT
Received: from maila14.newtekwebhosting.com (MAILA14.CRYSTALTECH.com [216.119.106.130]) by GWA7.newtekwebhosting.com with SMTP
        (version=TLS\Tls12
        cipher=Aes256 bits=256);
   Sat, 18 Apr 2020 03:25:54 -0700
Received: from [192.168.0.129] (static.55.32.0.81.ibercom.com [81.0.32.55]) by maila14.newtekwebhosting.com with SMTP
        (version=Tls12
        cipher=Aes256 bits=256);
   Sat, 18 Apr 2020 03:25:19 -0700
From:   Delio Brignoli <dbrignoli@audioscience.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: usb: dwc3: gadget: Don't clear flags before transfer ended
Message-Id: <C9599B63-1C11-4EBC-AFCC-3A4F14830767@audioscience.com>
Date:   Sat, 18 Apr 2020 12:25:16 +0200
To:     stable@vger.kernel.org
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please apply the following commit:

Commit subject: usb: dwc3: gadget: Don't clear flags before transfer ended
Commit ID: a114c4ca64bd522aec1790c7e5c60c882f699d8f
Apply to: at least 4.19 stable, and 5.4 stable if possible. Note that all kernels from v4.18-rc1 up to 5.7-rc1 are affected.

Why apply it:
<https://github.com/torvalds/linux/commit/a114c4ca64bd522aec1790c7e5c60c882f699d8f> fixes <https://github.com/torvalds/linux/commit/6d8a019614f3a7630e0a2c1be4bf1cfc23acf56e>. Without this fix the built-in USB function source/sink test module fails to work with isochronous endpoints [1]. A side-effect of setting dep->flags = DWC3_EP_ENABLED; in dwc3_gadget_ep_cleanup_completed_requests() as part of disabling an ep is that a subsequent attempt to enable the endpoint will skip __dwc3_gadget_ep_enable() effectively leaving the ep disabled.

[1] Our gadget driver on TI AM5729 fails to work exactly like the built-in USB function source/sink test module when switching to alternate interface 1 because of the issue described above.

TI is currently using 4.19 and 5.4 stable kernels as the basis for their processor SDK kernels for their AM57x SoC and may switch to 5.4 stable at a later time. Thank you.

Kind Regards
—
Delio Brignoli
AudioScience, Inc.
USA Sales Toll Free 1-855-AUDIOSC
<www.audioscience.com> - <http://www.facebook.com/AudioScienceInc>



