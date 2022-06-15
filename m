Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A97654BFAF
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 04:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234457AbiFOCdn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 22:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231969AbiFOCda (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 22:33:30 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2BC315808;
        Tue, 14 Jun 2022 19:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1655260398;
        bh=tDGqBeEH87571LYV7ZipMUnbv8SDiXRnh1Y0I4qsNqU=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=KoRA8e/D+un1T69EIBPFXH0XVvRUlNpFTL2DbETWLfBpCk5HqmNF1MdftUvVW5St+
         X/T7ZVEZ7wKiL4F8myk67M8LFhYigmfELVraYW3FxslS/CsNedF6IU7cZ3sjNBWyuX
         78E5Oq74eHRVphvyt/liMnRt35/Y+kwk9a/v5E2Q=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.34.73]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N7R1J-1ne3QB2AzV-017pEa; Wed, 15
 Jun 2022 04:33:18 +0200
Message-ID: <45e08686-31dd-64bc-3139-0327526f033e@gmx.de>
Date:   Wed, 15 Jun 2022 04:33:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 5.18 00/11] 5.18.5-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:EhvjiTMlU+GHlRlhcYRO0ZUpm5IAvmybZ17hnowrwxOWuw+X3iQ
 yetuwvKjEiGpm5GOeITTWmRrssw232jTxGfrY6XsNkX1ULJygR4fPSdfrFg1cZfJQBcvHrv
 UbDeQ1cfx7YTmjzNQAn1jhl76gJ3OGiKAnoXreCXF1SrBz3Py5Ov74XrQRL4JeWSYIIyx68
 a1/nNVib4MATYenijRJDg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:SHJt7RVHoKY=:kdHM6HhMXh0OMkjtJ+xtSP
 5p/k7Ttigu7GkLFzdnRpNAXpJD0n7wPqSOXe2hiA6jvQvlnDxdnTFt6rOMqRr9aW1CpK1FsGh
 N+3wfaiBEIIApOS8T9O5fctxP9JeYKl6sJjWRx0WKc0EBjEr7MHtZWlfMFlK0jK2u/kZVsJv5
 /9UYvN5h1oZ0nmkUDGai/cuPInatl/3WFQ/tXOxorTnnxbonuBdIEYlZXDww5YCFHdXtIaFSV
 Cs88fIWFtUdA/w+muRDlnRCkh4E4w2dNsjWOZyrpKNajiEBHlF2f3CRxhkrly7aVwyBxpCwl6
 0fmSFDDX6tdaLmJJ2aQu4I/XDqCT/ZJtIczEuqW8Tw9W/85BeE41U0pGT461E3NUM+C2hqZ6i
 8cGQrDrULfdJCtkwt+igQ6vi+qQdYbNsswsaHgy6BSKo0YmTnTV3TrhwQQvx+xU5c+NtlZMaP
 4NqMPuC+NWoUDRwUhUEaAKfSAlzYblXO+c/9k0wYmU1iXHJMWXg3E/8fwVDrPTm3ZVsOvEziE
 9qs1YKWCM+9TExrPy7HXuqt3NmIokFSAx57/XmsqtNFYsN9a6d2ZxZNy8UPngLnCLHZVzKsZp
 +FTJEvgoRcQ8nnFt3wKOXScnjI5V7ZdwwFInrISBOElMZOSOUM7PKb5OaQYrvcK7HBtRek9eQ
 VhWtx5+NxHRGFmOKgQMxnlzpemimEYW9fdhfmmMpav+SSSTAroZYn+u1Iv1XqCPIi6q2JCnU+
 Q3b+Wa+eKh38u/uxlpQNcxQZnAcEthSakae/o77H0p0umcskOq03zF4WdlJzE2UgN+Z7kcXME
 GkK3g5pzp9mU6hEgK8vOFKdAbhmhumNWkLGIkCcPvhZ4Bct1DgpBZfYe40Ctwzgx0sQMBSowc
 PuTwaueS2FlS9wO3TQYmjFq5lmwlEUXbcWHygzUp4UyDwfnu/8+SGQt09znUUXswzM/xz+ARz
 3iMZ1uBO2d2ksnOUEmY1mKgKCrrPipfs488toUWQxmQu3kCAKdWsVY17uDEFQdjCf/a6j/GNO
 ZTrgTmdet5VDUdAwJcfPrecoWPi99YIQARM8ROHhyY699yhoO2zuTx989DMZ0tfIeJJV77+AL
 NKsOdlLsIl2fDWKg1slJ6eEJ/1PqqZBJZkV
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hallo Greg

5.18.5-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 36)

Tested-by: Ronald Warsow <rwarsow@gmx.de


Thanks

Ronald

