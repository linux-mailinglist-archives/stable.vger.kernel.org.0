Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D88DF527373
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 20:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbiENSWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 May 2022 14:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiENSWv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 May 2022 14:22:51 -0400
Received: from mail.pekanbaru.go.id (mail.pekanbaru.go.id [103.131.245.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C4B20BEE
        for <stable@vger.kernel.org>; Sat, 14 May 2022 11:22:45 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.pekanbaru.go.id (Postfix) with ESMTP id 3C3DB9A39C3;
        Sun, 15 May 2022 00:06:33 +0700 (WIB)
Received: from mail.pekanbaru.go.id ([127.0.0.1])
        by localhost (mail.pekanbaru.go.id [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id EsjL8jFUtQd7; Sun, 15 May 2022 00:06:32 +0700 (WIB)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.pekanbaru.go.id (Postfix) with ESMTP id 3B6F89A399A;
        Sun, 15 May 2022 00:06:29 +0700 (WIB)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.pekanbaru.go.id 3B6F89A399A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pekanbaru.go.id;
        s=EA5C5C9E-4206-11EC-835B-1ADACEA726A0; t=1652547989;
        bh=pXowClvSMadVxtAvZAzaFtXDeoyeipc9hDqwekVPVSM=;
        h=MIME-Version:To:From:Date:Message-Id;
        b=X45Nik3FzsEBvFM0KZO73PgkVO1iujrFIIBfb8dMCxwgqcB6NaUECSt6+NYFG0Bm/
         rBB1iF16BHyzEIQAhlTU/PUJTZvqUFw5hvZrAwtwkUNYM/Ep5JV+g5Yr5ysk86PG3P
         a1IJ5oNIjCxOpuiY4pDLyZZFgGGWiDmNfTPcJmxCZUmpq53USstMpeF5tJLKNq/23I
         u3fOeefcbd0Ot9e1oUlSqEhDiLhfdNyBUCIyoMB6m7DFSQwDCowCS2Hm9HDOo07vGE
         66kwqJ0QLD3eK1ILRM0xrXbHUxhe1PvR4STPF7D6yxUzGOlhOsJJ186X+zUSF7y9W/
         ZdQ6dBx833F4A==
X-Virus-Scanned: amavisd-new at mail.pekanbaru.go.id
Received: from mail.pekanbaru.go.id ([127.0.0.1])
        by localhost (mail.pekanbaru.go.id [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 6FB9C3fqpZtJ; Sun, 15 May 2022 00:06:29 +0700 (WIB)
Received: from [192.168.15.103] (unknown [197.234.221.21])
        by mail.pekanbaru.go.id (Postfix) with ESMTPSA id A562C9A3959;
        Sun, 15 May 2022 00:06:17 +0700 (WIB)
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Are you there
To:     Recipients <waterproject@pekanbaru.go.id>
From:   waterproject@pekanbaru.go.id
Date:   Sat, 14 May 2022 18:06:04 +0100
Reply-To: test@hostnextdoor.com
Message-Id: <20220514170617.A562C9A3959@mail.pekanbaru.go.id>
X-Spam-Status: Yes, score=7.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_BL_SPAMCOP_NET,
        RCVD_IN_PSBL,RCVD_IN_SBL,RCVD_IN_SORBS_WEB,RCVD_IN_VALIDITY_RPBL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: *  1.3 RCVD_IN_BL_SPAMCOP_NET RBL: Received via a relay in
        *      bl.spamcop.net
        *      [Blocked - see <https://www.spamcop.net/bl.shtml?103.131.245.194>]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.1 RCVD_IN_SBL RBL: Received via a relay in Spamhaus SBL
        *      [197.234.221.21 listed in zen.spamhaus.org]
        *  2.7 RCVD_IN_PSBL RBL: Received via a relay in PSBL
        *      [103.131.245.194 listed in psbl.surriel.com]
        *  1.3 RCVD_IN_VALIDITY_RPBL RBL: Relay in Validity RPBL,
        *      https://senderscore.org/blocklistlookup/
        *      [103.131.245.194 listed in bl.score.senderscore.com]
        *  1.5 RCVD_IN_SORBS_WEB RBL: SORBS: sender is an abusable web server
        *      [197.234.221.21 listed in dnsbl.sorbs.net]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi =


Did you get my previous email? I have attempted to open up communication wi=
th you. Please acknowledge if you receive this email. =


Regards
Morten Friis
