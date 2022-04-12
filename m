Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 385C04FE026
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 14:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352860AbiDLMab (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 08:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353672AbiDLM2P (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 08:28:15 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C856EB7F7;
        Tue, 12 Apr 2022 04:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1649763564;
        bh=PhM8epyNMetmc7GMso7wIi9MAUvxCU1ngTOcIcDRFUQ=;
        h=X-UI-Sender-Class:Date:From:Subject:To:Cc;
        b=JOy6qILe7JdPfLRYdgQem8wS+05FEmWFq1zfIAhs7jS6h1SqmRn5mgViKe6bsWLX7
         urZE72e+acIsOMwgRfVoDZYwpWDmiAvnGrWn56y4+lIRwUqUswMWmBe2pKlsA8TMK8
         vWRNhqtC593hqUgzsOAL5blKJGwcZh8mCWdg5E/Y=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.35.129]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MaJ3t-1nPZj43Rbh-00WHQp; Tue, 12
 Apr 2022 13:39:23 +0200
Message-ID: <8541c671-8b0b-0311-b72c-def0ab8aaba8@gmx.de>
Date:   Tue, 12 Apr 2022 13:39:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
From:   Ronald Warsow <rwarsow@gmx.de>
Subject: Re: [PATCH 5.17 000/343] 5.17.3-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:lnhlkoe+hQq5Um5NMUdLRLb3jh2MlExUewspBFngsiEB7xP7N3S
 wNUVp5OY5H2ZMWuQ4b8dlsJzrzifNO1CJngHXe/TtUyRLBHm/sF9dNP3drTGZSx7BZMmV1G
 zny/EN6vbqDIaTuJn0lmQiwmYLdCe+cFgoz/rMRM3ToZeRnlxprgBfnJB5pyM+rUHD9bHKr
 UJdweqV3e73oR+yPocuXw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:PvJho4+mXOQ=:fd5gN6Etv6mwK9ZDox9DvZ
 tLBdj1qGXe6Z7l5LokZRq0E5D1b7bwPCH61sv6lEbumxECJKRcxIzf59/UBNApDMDbh/0daVE
 NYuTeWPNQn9shhbzvvWTgiffrUcTzPGYdWTrx5hOO4MdZs8GNJMCfUfj6mAvFVfeJ4WppM5Uc
 1yqR9dx0o+SdW/Yjz/8jBCYv22no76lEwekqc1KI9VV19VRsAzqrocAu7uPjoWAN6JwyGC41I
 cdbacuJt48LmMs0QJ8O4pQobzxk79n7GtkosFQlEG9i+LYgaxT5D+izL6ZhrpFc5fJkltzJ6z
 +WM50ADrJruOykmHu0RXlku6Ry4uOPDKDEkmcMTERsLNgMEK1oFI81qgqUwieAlmE1TWAgd0V
 zgIHiJMNy5C65tVR36SKQHj+7ih8uNAwTnGK4numrTfeWE7IyZ//0cFp3fuhPxTRqXDAxxdbQ
 3ll51GlF1e16q1PsQKWErXsUgW0wCw9p2EaZhNdW6/LWGl4re93NAGwamjyUceDmWGjpP35Us
 jxKJP+rkzgAaPjgO4hpfmfgM/t/unH2P6F+X971pxlnCzG4NA5uUXW1PjvfEeUMx4ilfHZmwb
 u+LdSU1LZXFBpTgXK9cVPErQcx0t2vme+8SoDxRdm0WgsNip6/JrHFzzIr40KCe0LMNkGm7w3
 a5d/czCjGUCAVdQdYXQoLrpSz7matQvoBq3JDfHkPNjka5eN8iKDDfxCQredun5JqIdd7n+40
 0nDSf9ncM1WvJJDwAtpJhITcXSnmP24aP/sEuhFnIhathza663GvAaSvsm2It/m4o5mHxkMF7
 56Q6F0YFlK8b5cABhIa08M2fVd1eDktZ7MHZAXK8f2q33MwVkW8q4WCDgfZ5LTeo8H2AFm5P3
 dcPKh57CsLksKbMEvGOQR6vuS4Y+E8h7Nd7w0O9/FiiG3YrmWRMPurThWdy363kSAZvWRGPmZ
 /mCj1DwxOS0rfCJJrkRMSXCA26AoHEcx8o1nxbIvoO02ZYw8RzZ3+KKTG24LIHnIaeuahKgya
 HY8egq/B22b4sbChjCnIiJbKAUleB2dQbDt4yAB1IAb87eYZxshGmnONEKg1i+snodQKWvnVp
 bhkx6y0hHU0M10=
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FAKE_REPLY_A1,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hallo Greg

5.17.3-rc1

compiles, boots and runs on my x86_64
(Intel i5-11400, Fedora 36 Beta)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

Ronald
