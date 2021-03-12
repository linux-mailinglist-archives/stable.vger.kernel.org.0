Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9092A339272
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 16:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbhCLPxi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 10:53:38 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54200 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232209AbhCLPxg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Mar 2021 10:53:36 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lKk6W-00AYSA-I3; Fri, 12 Mar 2021 16:53:32 +0100
Date:   Fri, 12 Mar 2021 16:53:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Gregory CLEMENT <gregory.clement@bootlin.com>,
        linux-arm-kernel@lists.infradead.org, pali@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH mvebu + mvebu/dt64 4/4] arm64: dts: marvell: armada-37xx:
 move firmware node to generic dtsi file
Message-ID: <YEuOfI5FKLYgdQV+@lunn.ch>
References: <20210308153703.23097-1-kabel@kernel.org>
 <20210308153703.23097-4-kabel@kernel.org>
 <87czw4kath.fsf@BL-laptop>
 <20210312101027.1997ec75@kernel.org>
 <YEt/Ll08M1cwgGR/@lunn.ch>
 <20210312161704.5e575906@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312161704.5e575906@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> So theoretically the turris-mox-rwtm driver can be renamed into
> something else and we can add a different compatible in order not to
> sound so turris-mox specific.

That would be a good idea. And if possible, try to push the hardware
random number code upstream in the firmware repos, so everybody gets
it by default, not just those using your build. Who is responsible for
upstream? Marvell?

	  Andrew
