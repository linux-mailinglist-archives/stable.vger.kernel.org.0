Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A9C381F95
	for <lists+stable@lfdr.de>; Sun, 16 May 2021 18:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbhEPQIW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 May 2021 12:08:22 -0400
Received: from manchmal.in-ulm.de ([217.10.9.201]:53612 "EHLO
        manchmal.in-ulm.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbhEPQIW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 May 2021 12:08:22 -0400
X-Greylist: delayed 407 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 May 2021 12:08:22 EDT
Date:   Sun, 16 May 2021 18:00:14 +0200
From:   Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
To:     stable@vger.kernel.org
Subject: Re: 5.10.37 won't boot on my system, but 5.10.36 with same config
 does
Message-ID: <1621180418@msgid.manchmal.in-ulm.de>
References: <e0e9ecf4-cfd7-b31a-29b0-ead4a6c0ee40@charleswright.co>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0e9ecf4-cfd7-b31a-29b0-ead4a6c0ee40@charleswright.co>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Charles Wright wrote...

> I see a couple of other posts with same issue.

Count me in. It's not a global issue, though, various machine rebooted
without any problems. Only failing device so far was an old x200
Thinkpad - stalls before console gets intialized, so I have no idea at
all what went wrong there. And I'm sorry, I don't have the time for
bisecting at the moment.

    Christoph
