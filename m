Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA6A13488AA
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 06:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbhCYFzh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 01:55:37 -0400
Received: from 99-33-87-210.lightspeed.sntcca.sbcglobal.net ([99.33.87.210]:33118
        "EHLO mail.aaazen.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbhCYFzg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Mar 2021 01:55:36 -0400
Received: from localhost (localhost [127.0.0.1])
        by thursday.test (OpenSMTPD) with ESMTP id 217e4913;
        Thu, 25 Mar 2021 05:55:26 +0000 (UTC)
Date:   Wed, 24 Mar 2021 22:55:26 -0700 (PDT)
From:   Richard Narron <richard@aaazen.com>
X-X-Sender: richard@thursday.test
To:     stable <stable@vger.kernel.org>
cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel test robot <lkp@intel.com>,
        Alexandru Ardelean <aardelean@deviqon.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH 5.11 093/120] iio: adc: adi-axi-adc: add proper Kconfig
 dependencies
In-Reply-To: <20210322121932.787548436@linuxfoundation.org>
Message-ID: <alpine.LNX.2.20.2103242247200.7953@thursday.test>
References: <20210322121929.669628946@linuxfoundation.org> <20210322121932.787548436@linuxfoundation.org>
User-Agent: Alpine 2.20 (LNX 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Slackware changed their 5.11.8 configuration for 5.11.9.  The simply
turned off ADI_AXI_ADC and AD9467...

To keep a copy of the original 5.11.8 configuration around for testing I
saved it as an attachment to bugzilla 212433:

https://bugzilla.kernel.org/show_bug.cgi?id=212433

https://bugzilla.kernel.org/attachment.cgi?id=296047
