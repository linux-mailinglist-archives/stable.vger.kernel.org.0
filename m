Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0F3236BA4F
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 21:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241079AbhDZTw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 15:52:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41728 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241076AbhDZTw7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 15:52:59 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lb7H7-001Eqc-0j; Mon, 26 Apr 2021 21:52:09 +0200
Date:   Mon, 26 Apr 2021 21:52:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH mvebu + mvebu/dt64 4/4] arm64: dts: marvell: armada-37xx:
 move firmware node to generic dtsi file
Message-ID: <YIcZ6cUSzp/1/liH@lunn.ch>
References: <20210308153703.23097-1-kabel@kernel.org>
 <20210308153703.23097-4-kabel@kernel.org>
 <87czw4kath.fsf@BL-laptop>
 <20210312101027.1997ec75@kernel.org>
 <YEt/Ll08M1cwgGR/@lunn.ch>
 <20210312161704.5e575906@kernel.org>
 <YEuOfI5FKLYgdQV+@lunn.ch>
 <20210315101454.dpyfdwk43poirxlw@pali>
 <YE9OMFHwLi8q0qnb@lunn.ch>
 <20210426183612.kj5g3wklgue3gx55@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426183612.kj5g3wklgue3gx55@pali>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Ok! What about compatible string "marvell,armada-3700-rwtm-firmware"?

Yes, that is O.K.

     Andrew
