Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72B1B413574
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 16:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233612AbhIUOhi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 10:37:38 -0400
Received: from smtprelay0225.hostedemail.com ([216.40.44.225]:54300 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233153AbhIUOhi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 10:37:38 -0400
X-Greylist: delayed 323 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Sep 2021 10:37:38 EDT
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave02.hostedemail.com (Postfix) with ESMTP id 439D618094612
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 14:30:47 +0000 (UTC)
Received: from omf13.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id BCA2C100E8946;
        Tue, 21 Sep 2021 14:30:45 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf13.hostedemail.com (Postfix) with ESMTPA id AA8351124F5;
        Tue, 21 Sep 2021 14:30:44 +0000 (UTC)
Message-ID: <5662a5175932e46febd024cadc4bece443aa92c0.camel@perches.com>
Subject: Re: [PATCH 5.10 116/122] bnxt_en: Convert to use netif_level()
 helpers.
From:   Joe Perches <joe@perches.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Date:   Tue, 21 Sep 2021 07:30:42 -0700
In-Reply-To: <20210920163919.617145875@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
         <20210920163919.617145875@linuxfoundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: AA8351124F5
X-Stat-Signature: 47r6m7tm9am138y3xbpp3f45rm4djjie
X-Spam-Status: No, score=0.09
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18jqXDlEvVf6U35T89H8Lq60N1TvQBK/p0=
X-HE-Tag: 1632234644-269152
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2021-09-20 at 18:44 +0200, Greg Kroah-Hartman wrote:
> From: Michael Chan <michael.chan@broadcom.com>
> 
> [ Upstream commit 871127e6ab0d6abb904cec81fc022baf6953be1f ]
> 
> Use the various netif_level() helpers to simplify the C code.  This was
> suggested by Joe Perches.

There isn't an actual change here.

Unless this is a precursor to another patch, this isn't anything
that should go into stable.


