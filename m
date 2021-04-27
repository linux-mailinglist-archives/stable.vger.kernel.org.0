Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8927B36C66C
	for <lists+stable@lfdr.de>; Tue, 27 Apr 2021 14:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236345AbhD0Mwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Apr 2021 08:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235426AbhD0Mwk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Apr 2021 08:52:40 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61DD6C061574;
        Tue, 27 Apr 2021 05:51:57 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lbNBy-000hKt-FE; Tue, 27 Apr 2021 14:51:54 +0200
Message-ID: <5bff6cb9af78142a799ee804137a9f530ad30445.camel@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: fix locking in netlink owner interface
 destruction
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Harald Arnesen <harald@skogtun.org>, linux-wireless@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date:   Tue, 27 Apr 2021 14:51:53 +0200
In-Reply-To: <07e5bcb9-7de3-2e0a-cdeb-adc0dd4f1fd4@skogtun.org>
References: <20210427114946.aa0879857e8f.I846942fa5fc6ec92cda98f663df323240c49893a@changeid>
         <07e5bcb9-7de3-2e0a-cdeb-adc0dd4f1fd4@skogtun.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2021-04-27 at 14:07 +0200, Harald Arnesen wrote:
> I can confirm that the machine reboots with this patch applied.

Great, thanks!

johannes


