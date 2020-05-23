Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D69E21DFA25
	for <lists+stable@lfdr.de>; Sat, 23 May 2020 20:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387660AbgEWSLl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 May 2020 14:11:41 -0400
Received: from muru.com ([72.249.23.125]:55632 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726865AbgEWSLl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 23 May 2020 14:11:41 -0400
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id 87AB980F3;
        Sat, 23 May 2020 18:12:31 +0000 (UTC)
Date:   Sat, 23 May 2020 11:11:38 -0700
From:   Tony Lindgren <tony@atomide.com>
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     Evgeniy Polyakov <zbr@ioremap.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        YueHaibing <yuehaibing@huawei.com>, linux-kernel@vger.kernel.org,
        kernel@pyra-handheld.com, letux-kernel@openphoenux.org,
        linux-omap@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/4] w1: omap-hdq: fix return value to be -1 if there is
 a timeout
Message-ID: <20200523181138.GF37466@atomide.com>
References: <cover.1590255176.git.hns@goldelico.com>
 <b2c2192b461fbb9b8e9bea4ad514a49557a7210b.1590255176.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2c2192b461fbb9b8e9bea4ad514a49557a7210b.1590255176.git.hns@goldelico.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* H. Nikolaus Schaller <hns@goldelico.com> [200523 17:34]:
> The code accidentially overwrites the variable ret and not val,
> which is returned. So it will return the initial value 0 instead
> of -1.

Oops, sorry about causing this. And thanks for catching it:

Acked-by: Tony Lindgren <tony@atomide.com>
