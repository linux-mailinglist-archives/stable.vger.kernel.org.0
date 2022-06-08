Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4642B5425AB
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 08:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiFHEQQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 00:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235288AbiFHEPQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 00:15:16 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B3A2DABE9;
        Tue,  7 Jun 2022 18:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1654652208;
        bh=F/hC4Ta91+MBvEtrfFRwcu+EM80PRQ88/zTa1O8JHmo=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=SI6PZ3BHgrsJVTHNIcOwddtpjA6ObvCJPrw+Jao04ZzyEtTuPoCxzxpXeGg0r7qx4
         QDk2NEoqYPBW4pRJSEA6Y+innfViZUrBivEDu3Z/k6FMdY5MLqRYh/FcPbUUlEYKRN
         Wyx48qKL22i+LWsd9Ja8QS8jhjsz31z4ANFPwP6s=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.34.212]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1Mw9UK-1nfqe9127I-00s9Wv; Wed, 08
 Jun 2022 03:31:33 +0200
Message-ID: <46c192f3-2d67-f381-0d18-dbf44caf423f@gmx.de>
Date:   Wed, 8 Jun 2022 03:31:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 5.18 000/879] 5.18.3-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:RIUL6k9W12GjyPIpaIRURA9lXLAJ+FFA4da3d00e0fZqX1nldv0
 Jb3i1v00IK8xLUI5jBC7j+1rJ3PnOt8zMpBe3AzmQ/BgdWYkw/NEGdWWIgWN56j7jffHYBT
 9awV5WRPT8Q+E3dmH2iMJ5XiIz5BaXP0n8NRFleEGZyRyWmX6WM0lbZYLiUhrMXNt6kZi8T
 7IbC5RMhjtOGYGW7WgSDQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:awNr+0wvER0=:vy6VRgH4Q/w4pXy7TUuubd
 ZFqRlLdg3QJakEFepwyVQc7s8HPjFNHRD02OUkGQawCPR5N5TlHsTexOFwO/Dhzw+VwJ4br+H
 rYnuioHFZ2qU0FkdHd9P6iDwxZF2ouBM7zCStl5jayr75ImKN3+q30Fra6GkEb6m9Sd7FPKmX
 iaWC6ImEdBkAP/WZL8fR3FrulwFmnOEPguVTsxraikynysGzFOnNL45vXMaAd1dPmZWaQ6EHZ
 XG2wMevNY4edir+3HNpviFzuUXghK/qKtt3PlKIa+XDJC0lUEyNb2ZmFnp9CppumBQ5+xqlV/
 fXqV6PjPL6A7NLS1ss4pgMmd6qzAXn5BUK4y0wPL5ICaliH4nlz+sCO1Y4heXeA6r6I9UVus/
 Bpn+xX1TljS2RWiQ2diPgCoHjJATQJmqZUSgEsLWNSoyRU7BXLtW3mGWhpLX82NsWRJpWZ929
 hWRmabFmYIsb3OyqJi/fx26bp2zfVgMx3O7va57BODSpzR6ekOo6HqGBSZOL6JqfW/8v4t0E7
 PS06uGGfVtLd1v+JVi5imVIshoLW9QgO2PI6k6HwbkMxLEab2TEG/mERgZ3d0OxVVxA3cBYmf
 RMp1F4OTK5GTeWKglhPRQ7LT0+Oh5w8fddqYgnZy4KIXgnqFeS4rLqnJcbNVyTLpp/jCHmJ+D
 Henq3UY7n6mHK2tYNsDy8I1VTqaHqUWmO5P9bNR3L4hcYq9b27iABAtTumSjnfh7jlgmxgySL
 tJTM7jWBC9MPlyLls2enrE5xnrRio9kcXZ2BeKAQ5+pewmDcO+yiy/Jn1Eiu3iXV1rdJzCIEp
 2Bne5V8OJsSTKT1ASTB2kMPYj/e3BCy4PMXvLWGH7dd+jjg3v0JJ3YORRlnKehyDSsx3MGsv0
 p9MQmwnNRPH7UAr0ecBJcj3FVjdclS7MKB9y7PeG7y1pteQXj8UpVjz1CHdAWcvX8RE8KRMuO
 7JEQlMrr+HnmHz0GZ37Y/IzeeiIt4v0EiNNlobioKgenO/e3FakNkzeuWILFCeeTgvxEHiQmZ
 ysXzuxrFfat8q552PazcqKGQKPrZ8iWwLVJZez+Xrrzm6RXvIRii4uLSiTFhuhuIiG+itHj6n
 OFQR2Cu3i1thmN8wXimAHDbNL0UkCYDXj20IVZUEqQ4ZaV4KxOFBhTkiw==
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

5.18.3-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 36)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de

Ronald

