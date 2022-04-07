Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B581F4F87DE
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 21:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbiDGTQ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 15:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233095AbiDGTQu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 15:16:50 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE7B2493CE
        for <stable@vger.kernel.org>; Thu,  7 Apr 2022 12:14:48 -0700 (PDT)
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com [209.85.160.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 223933F1CA
        for <stable@vger.kernel.org>; Thu,  7 Apr 2022 19:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1649358878;
        bh=Gzlkl82iNh6p2MQs40tA2lR1NS6/TV0CZjY6WZ5QtGY=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=PmhARUY1+k7lkxjgxTzvfsR6sop+bAROLAIPJwoQ3UPZ2CFvZ1uU10bB2TGW33sSQ
         M1yRSjX8C/zh51y4ZzLfpct5ovDfEWgMKAvmLiAgPSZ4pOyfFXO/4LQD49PhlyS1MO
         YsuXZ0Hd3FIoYfJKPwYnxB4yfYuXVy3kjJzQd04UmHBfIBHuYroz4T9u7QGDrlDBAd
         Ks2PwasUKhDqAMOZKjMnBl4i8oN8urMZy2NnFVzSEWpqrinZDtUbTd2kSilG1TpDNz
         1ooYNkvw+NP+Z6c/Gnu1OBAqqWcQQ31AVhLld3QtcRW7vsmoja64gehzxA2PVJImrE
         T8zyrNTqw6lEA==
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-d414acc367so3475178fac.23
        for <stable@vger.kernel.org>; Thu, 07 Apr 2022 12:14:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Gzlkl82iNh6p2MQs40tA2lR1NS6/TV0CZjY6WZ5QtGY=;
        b=SfvaGycF9hyygUle5UYmPECNUMv4+tsWHZiWAP1/vNPnngf1RSTkipopPDuPAaJMKj
         R9QFflL+1ke7cTRDXCccc2icw/EEDKTgHcMXiSUxCkN156PqIoi2zJEX5tqYHfKWC4Va
         TKxVokQMzYVYdla+ANkt1zbR+2PEVC1C4Oll1P+dYWhrGhJlED7CNgU+vlLN4SD54xwI
         ZwxBbQYvhCbB1ya0kkw0SYaTRhgQkC5Succ5riPWcpFk/X059yARX8AN/GpAfPu5ivhq
         uytJ16RsdLT8dpcLn99fUlqm916v8zFvsK2Vur1EJ0QHgbLR5iIH5bHIQYogXqbnQtYm
         Gxhg==
X-Gm-Message-State: AOAM530PjohgX7fCUV2BiosMMZJh61WYbr92mjpLZAk05VjVIu8t0ZBV
        3uutfSkIeoEsgtdPrDQpaEGWqqNeVIfgLKeKMzqTaB6JaAgU2jxZeUwOnSoyS52uQ2e31lDapIk
        CwoxWvk640l20Gya8Lah7xCsm60lOVA/ttg==
X-Received: by 2002:aca:3c82:0:b0:2f4:8c9a:b81e with SMTP id j124-20020aca3c82000000b002f48c9ab81emr6377757oia.152.1649358876417;
        Thu, 07 Apr 2022 12:14:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzvmogfbnPxNDyfmkzn6LqiTpNnrmXEmZtWOPL3ruqajs7fsyXNDTEOkYQgyTRDqdxBM4l8/A==
X-Received: by 2002:aca:3c82:0:b0:2f4:8c9a:b81e with SMTP id j124-20020aca3c82000000b002f48c9ab81emr6377743oia.152.1649358876116;
        Thu, 07 Apr 2022 12:14:36 -0700 (PDT)
Received: from mfo-t470.. ([2804:14c:4e1:8732:bf86:1224:e21c:d4ae])
        by smtp.gmail.com with ESMTPSA id m5-20020a056870194500b000d9a0818925sm7844120oak.25.2022.04.07.12.14.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 12:14:35 -0700 (PDT)
From:   Mauricio Faria de Oliveira <mfo@canonical.com>
To:     stable@vger.kernel.org
Subject: [PATCH 0/1] mm: fix race between MADV_FREE reclaim and blkdev direct IO
Date:   Thu,  7 Apr 2022 16:14:24 -0300
Message-Id: <20220407191432.1456219-1-mfo@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 6c8e2a256915a223f6289f651d6b926cd7135c9e upstream.

Backports for stable:

- folio/page differences on 5.17, 5.16, 5.15, 5.10, 5.4, 4.19;
- context lines differences on 4.14;
- conditional/gate differences on 4.9;
(changes described in each commit.)

Test-case with good results on all versions
(consistent values read on good/bad binary).

Links:
- FAILED: patch "[PATCH] mm: fix race between MADV_FREE reclaim and blkdev direct IO"
  failed to apply to <version>-stable tree
  - 5.17 https://lore.kernel.org/stable/1648897548136182@kroah.com/
  - 5.16 https://lore.kernel.org/stable/164889755413570@kroah.com/
  - 5.15 https://lore.kernel.org/stable/1648897560105145@kroah.com/
  - 5.10 https://lore.kernel.org/stable/1648897566131152@kroah.com/
  - 5.4  https://lore.kernel.org/stable/1648897573389@kroah.com/
  - 4.19 https://lore.kernel.org/stable/1648897585112208@kroah.com/
  - 4.14 https://lore.kernel.org/stable/1648897579250122@kroah.com/

The 4.9 version is also affected; there was an issue w/ the Fixes:
commit id from v4 not picked up in mainline -- it should cover 4.9
(also described in each commits).

cheers,
-- 
Mauricio


linux-5.17.y:
===

Original:

	+ uname -rv
	5.17.1-dirty #4 SMP PREEMPT Thu Apr 7 16:58:35 UTC 2022
	...
	+ mv test good
	+ ./good
	0x7fe09a90a000: 0x79
	0x7fe09a90b000: 0x79
	0x7fe09a90c000: 0x79
	0x7fe09a90d000: 0x79
	+ mv good bad
	+ ./bad
	0x7f6fd0a41000: 0x0
	0x7f6fd0a42000: 0x0
	0x7f6fd0a43000: 0x0
	0x7f6fd0a44000: 0x0

Patched:

	+ uname -rv
	5.17.1-00001-g68e35ffe374c-dirty #3 SMP PREEMPT Thu Apr 7 15:10:56 UTC 2022
	...
	+ mv test good
	+ ./good
	0x7fa65e4f5000: 0x79
	0x7fa65e4f6000: 0x79
	0x7fa65e4f7000: 0x79
	0x7fa65e4f8000: 0x79
	+ mv good bad
	+ ./bad
	0x7fa6b92d7000: 0x79
	0x7fa6b92d8000: 0x79
	0x7fa6b92d9000: 0x79
	0x7fa6b92da000: 0x79


linux-5.16.y:
===

Original:

	+ uname -rv
	5.16.18+ #1 SMP PREEMPT Thu Apr 7 15:17:17 UTC 2022
	...
	+ mv test good
	+ ./good
	0x7fc0a4634000: 0x79
	0x7fc0a4635000: 0x79
	0x7fc0a4636000: 0x79
	0x7fc0a4637000: 0x79
	+ mv good bad
	+ ./bad
	0x7fe5bbd8b000: 0x0
	0x7fe5bbd8c000: 0x0
	0x7fe5bbd8d000: 0x0
	0x7fe5bbd8e000: 0x79

Patched:

	+ uname -rv
	5.16.18+ #2 SMP PREEMPT Thu Apr 7 15:22:21 UTC 2022
	...
	+ mv test good
	+ ./good
	0x7f98cbe1d000: 0x79
	0x7f98cbe1e000: 0x79
	0x7f98cbe1f000: 0x79
	0x7f98cbe20000: 0x79
	+ mv good bad
	+ ./bad
	0x7f0194098000: 0x79
	0x7f0194099000: 0x79
	0x7f019409a000: 0x79
	0x7f019409b000: 0x79


linux-5.15.y:
===

Original:

	+ uname -rv
	5.15.32+ #2 SMP Thu Apr 7 15:38:32 UTC 2022
	...
	+ mv test good
	+ ./good
	0x7f45b2dcd000: 0x79
	0x7f45b2dce000: 0x79
	0x7f45b2dcf000: 0x79
	0x7f45b2dd0000: 0x79
	+ mv good bad
	+ ./bad
	0x7f477d3a2000: 0x0
	0x7f477d3a3000: 0x0
	0x7f477d3a4000: 0x0
	0x7f477d3a5000: 0x0

Patched:

	+ uname -rv
	5.15.32+ #3 SMP Thu Apr 7 15:40:33 UTC 2022
	...
	+ mv test good
	+ ./good
	0x7f918fc47000: 0x79
	0x7f918fc48000: 0x79
	0x7f918fc49000: 0x79
	0x7f918fc4a000: 0x79
	+ mv good bad
	+ ./bad
	0x7fd6153f5000: 0x79
	0x7fd6153f6000: 0x79
	0x7fd6153f7000: 0x79
	0x7fd6153f8000: 0x79


linux-5.10.y:
===

Original:

	+ uname -rv
	5.10.109+ #2 SMP Thu Apr 7 15:44:15 UTC 2022
	...
	+ mv test good
	+ ./good
	0x7f94a3750000: 0x79
	0x7f94a3751000: 0x79
	0x7f94a3752000: 0x79
	0x7f94a3753000: 0x79
	+ mv good bad
	+ ./bad
	0x7ff2e7938000: 0x0
	0x7ff2e7939000: 0x0
	0x7ff2e793a000: 0x0
	0x7ff2e793b000: 0x0

Patched:

	+ uname -rv
	5.10.109+ #3 SMP Thu Apr 7 15:45:41 UTC 2022
	...
	+ mv test good
	+ ./good
	0x7f2948d1d000: 0x79
	0x7f2948d1e000: 0x79
	0x7f2948d1f000: 0x79
	0x7f2948d20000: 0x79
	+ mv good bad
	+ ./bad
	0x7fe22a9c6000: 0x79
	0x7fe22a9c7000: 0x79
	0x7fe22a9c8000: 0x79
	0x7fe22a9c9000: 0x79


linux-5.4.y:
===

Original:

	+ uname -rv
	5.4.188+ #1 SMP Thu Apr 7 15:47:54 UTC 2022
	...
	+ mv test good
	+ ./good
	0x7fc53e9a2000: 0x79
	0x7fc53e9a3000: 0x79
	0x7fc53e9a4000: 0x79
	0x7fc53e9a5000: 0x79
	+ mv good bad
	+ ./bad
	0x7f88ce4fa000: 0x0
	0x7f88ce4fb000: 0x0
	0x7f88ce4fc000: 0x0
	0x7f88ce4fd000: 0x0

Patched:

	+ uname -rv
	5.4.188+ #2 SMP Thu Apr 7 15:49:19 UTC 2022
	...
	+ mv test good
	+ ./good
	0x7fd64b54c000: 0x79
	0x7fd64b54d000: 0x79
	0x7fd64b54e000: 0x79
	0x7fd64b54f000: 0x79
	+ mv good bad
	+ ./bad
	0x7f15ba253000: 0x79
	0x7f15ba254000: 0x79
	0x7f15ba255000: 0x79
	0x7f15ba256000: 0x79


linux-4.19.y:
===

Original:

	+ uname -rv
	4.19.237+ #1 SMP Thu Apr 7 15:51:11 UTC 2022
	...
	+ mv test good
	+ ./good
	0x7fe8d78b0000: 0x79
	0x7fe8d78b1000: 0x79
	0x7fe8d78b2000: 0x79
	0x7fe8d78b3000: 0x79
	+ mv good bad
	+ ./bad
	0x7f1d1f6e9000: 0x0
	0x7f1d1f6ea000: 0x0
	0x7f1d1f6eb000: 0x0
	0x7f1d1f6ec000: 0x0

Patched:

	+ uname -rv
	4.19.237+ #2 SMP Thu Apr 7 15:52:24 UTC 2022
	...
	+ mv test good
	+ ./good
	0x7f2bdb6c9000: 0x79
	0x7f2bdb6ca000: 0x79
	0x7f2bdb6cb000: 0x79
	0x7f2bdb6cc000: 0x79
	+ mv good bad
	+ ./bad
	0x7f0e7af0f000: 0x79
	0x7f0e7af10000: 0x79
	0x7f0e7af11000: 0x79
	0x7f0e7af12000: 0x79


linux-4.14.y:
===

Original:

	+ uname -rv
	4.14.275+ #2 SMP Thu Apr 7 15:55:08 UTC 2022
	...
	+ mv test good
	+ ./good
	0x7fb22c1e2000: 0x79
	0x7fb22c1e3000: 0x79
	0x7fb22c1e4000: 0x79
	0x7fb22c1e5000: 0x79
	+ mv good bad
	+ ./bad
	0x7fec8aad6000: 0x0
	0x7fec8aad7000: 0x0
	0x7fec8aad8000: 0x0
	0x7fec8aad9000: 0x0

Patched:

	+ uname -rv
	4.14.275+ #3 SMP Thu Apr 7 16:23:22 UTC 2022
	...
	+ mv test good
	+ ./good
	0x7fdfabd3f000: 0x79
	0x7fdfabd40000: 0x79
	0x7fdfabd41000: 0x79
	0x7fdfabd42000: 0x79
	+ mv good bad
	+ ./bad
	0x7f25da5c1000: 0x79
	0x7f25da5c2000: 0x79
	0x7f25da5c3000: 0x79
	0x7f25da5c4000: 0x79


linux-4.9.y:
===

	# dd if=/dev/zero of=swap.img bs=1M count=1024
	# mkswap swap.img
	# swapon swap.img

Original:

	+ uname -rv
	4.9.309+ #2 SMP Thu Apr 7 16:30:41 UTC 2022
	...
	+ mv test good
	+ ./good
	0x7fb2ec63d000: 0x79
	0x7fb2ec63e000: 0x79
	0x7fb2ec63f000: 0x79
	0x7fb2ec640000: 0x79
	+ mv good bad
	+ ./bad
	0x7fdfaecf3000: 0x0
	0x7fdfaecf4000: 0x0
	0x7fdfaecf5000: 0x0
	0x7fdfaecf6000: 0x0

Patched:

	+ uname -rv
	4.9.309+ #3 SMP Thu Apr 7 16:48:00 UTC 2022
	...
	+ mv test good
	+ ./good
	0x7f8eeb60c000: 0x79
	0x7f8eeb60d000: 0x79
	0x7f8eeb60e000: 0x79
	0x7f8eeb60f000: 0x79
	+ mv good bad
	+ ./bad
	0x7f4696d1e000: 0x79
	0x7f4696d1f000: 0x79
	0x7f4696d20000: 0x79
	0x7f4696d21000: 0x79

-- 
2.32.0

