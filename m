Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40B7433027A
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 16:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbhCGPKx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 10:10:53 -0500
Received: from rere.qmqm.pl ([91.227.64.183]:55979 "EHLO rere.qmqm.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229976AbhCGPKQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Mar 2021 10:10:16 -0500
X-Greylist: delayed 568 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Mar 2021 10:10:15 EST
Received: from remote.user (localhost [127.0.0.1])
        by rere.qmqm.pl (Postfix) with ESMTPSA id 4Dtl5m1XrHzCG;
        Sun,  7 Mar 2021 16:00:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=rere.qmqm.pl; s=1;
        t=1615129246; bh=TXKaiRuxDWPYRiyXUg7cvjJD/PKqjv8eMiDxP5BDlt4=;
        h=Date:From:To:Cc:Subject:From;
        b=o8S60RTRwzCHABgWGslVhZPBvQk1yxoeW/k5nb0K46p2hrklaTlYV2/NrhZUZwDqp
         R28X4GU1EcB+2+9gKu8Tl9exc0eyOpWG2QkWdrNxnlF2/GOUranc4YoyJlMKWgykO+
         IyvKFtmZ/rZvktcwI62T+4stwV5iWE7oapgejaYPIy4HRsjDF8oCY0Q1H7+CJsVolj
         /Cmx7hZo71NNhrzI2US1rlUETHrL0saD8EMFr/Neo+nmpP8XH97wteOV1yebUjfEXx
         /EUljysD4tidQ8V27ZjgxISm2wz/FIj2y2zBHsuHJ4+Mx6xt60plLdxkrfzW84QyiF
         tLdQmIRRmdPyg==
X-Virus-Status: Clean
X-Virus-Scanned: clamav-milter 0.102.4 at mail
Date:   Sun, 7 Mar 2021 16:00:40 +0100
From:   =?iso-8859-2?B?TWljaGGzoE1pcm9zs2F3?= <mirq-linux@rere.qmqm.pl>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linus Walleij <linus.walleij@linaro.org>, stable@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: stable: KASan for ARM
Message-ID: <20210307150040.GB28240@qmqm.qmqm.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Greg,

Would you consider KASan for ARM patches for LTS (5.10) kernel? Those
are 7a1be318f579..421015713b30 if I understand correctly. They are
not normal stable material, but I think they will help tremendously in
discovering kernel bugs on 32-bit ARMs.

Best Regards
Micha³ Miros³aw
