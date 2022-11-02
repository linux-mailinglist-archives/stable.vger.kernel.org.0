Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF26D616E25
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 21:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiKBUA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 16:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbiKBUA4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 16:00:56 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E603A9;
        Wed,  2 Nov 2022 13:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1667419253; bh=tDaAl8wMewvB6cloUZWJXVNMG6+JRsZW4moZsDfgz3M=;
        h=X-UI-Sender-Class:Date:From:Subject:To:Cc;
        b=l3twHfn2lJwHfZsrduYoXmCmbvLg0gERZAbXpeAHGtsg53O+ft9SGcccIaPqoiIqU
         gGziccqtWJa8Z/r13DflkfMF3ehGNMR0ss+AcNQkOSbHgUCHw+w0dNIoeFlczBgTZE
         NKWFET58rW0ro6KtQWe9T7bdDUfI/yVGvTP13ht6xnGT76y9uCdO1qq4qMLXTeTAai
         Hmcgb5IRU28ssCQMkCk5mWzJR1GOSYZjjrp6kRPrkj/kqS5+7PcACXimpXsm3uxMi8
         PBOCoRt2jR8OfIi1cFC/ncwgV0d3ny9bgJ7NG5PgIDXvvXRymQJ1nj1W3gKYRWMbEW
         ZVLmwPVcdocbQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.100.20] ([46.142.35.174]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MrhQC-1pM8132UU8-00neYK; Wed, 02
 Nov 2022 21:00:53 +0100
Message-ID: <523c38cc-e302-01f1-70d5-09f797d85feb@gmx.de>
Date:   Wed, 2 Nov 2022 21:00:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
From:   Ronald Warsow <rwarsow@gmx.de>
Subject: Re: [PATCH 6.0 000/240] 6.0.7-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:Awad4/L+uOF3t1uoZZIb1Vz5E2vvDubzZns6smD/rMZtDg5krGv
 ohmu17qfvNTKrL2S3VGvdCQElzE4VAlDXL+rqbwpkaHB9/8r2W7hDD18QXLAdf3CmK7N9c9
 /7isAL6AO1urocinyDxuOG+Vd5V82kOCeVtc5KSEmL/im072uZ7fu+iei6f1UktpGAoqusV
 AoFFC0RnDwq2iMRQYLK8w==
UI-OutboundReport: notjunk:1;M01:P0:/HA5iKM78pc=;OC+/tyYlhzkQgGtkEmI8picDNoV
 6DolkPk3u1gaKmvgtjmxzbhOXUXgc0t1kD7TuxXKebF3YUl0Gm+8iuMqzS8MKDAMW/MgxP1I4
 o4gVjZp5EzUOQDlVHA3P8HcBYJliQbUcMyTlNi+iKHG10dysYxHhnt3hYVG79aE/pd+NVlmQd
 oOOAH01UG6nwAK0ojU9qqGTFB1o4jnWoA8kD6GWU5Kp3RkJh6TGL43ZbWcI4XThIt+YA8zp1u
 yfR3Kc3nEi0DmRFAeCF/KG0RVwzRViVhsCMO72A6PvcGku14wDskJhTx8sOdlaNz7xdn1LrA2
 y5LenEF7C1KD1nhrKouDNGmjBwrzRkYJSesLCINPxSTmiPoJlmxmYjZdIyKy2ae3bTMF8bhM8
 6Oz3BNWdtgrpSLuVPJlf02aNZ0noY/vPZ6wpLrnvjjlTNkT5rFtK/m2q/5UEW2krFp6wh7PUW
 gnRh07SxU+vkP2mGVb/1aqOIYVNDuqNrICiqj9T+sEW0opJE/YYPISE/WRAm5OA7fg1tUnAch
 XXigpRQDpYWA+f72Qp40kHx/kKMxeuquCI5oPk3QjBLWrgFe8GTZnaPZLG0sdy3hPb+H3PIaW
 dC/RUx+9sM4H+BdVJTfoscDUM8kbfmQEZ2Q9/0gOQdBeo4K9vt6GHwDeuk3Wid/vxklnjA0CX
 PYkbPduACMRN2i6p3+ilzOffbycXhrCLOjc77LLl/rrSqvkVcVrH/22IoNKa2gXdmJQGlWiKM
 PKsIzJeu6CINc+X2PtbnZc5areZhWtV42eZDeyx8Wt89tQFRHqfecqtbzkvnZNEMH27eW6Gvv
 3R9at2C7vUzlck82dqnZ6eEx8EXYtzRI5eRazrPBNCo5t2gHydBbeT7NPgkTjFT2WmLm4V+I9
 X2kDtt0moc0XRsOQRFHQmQ/U7IZUaUgMdPKfmV7tMplt+EfpLt2kwgXnZa9Ec5alA96BL/feR
 dxrmwkqNaDPxjLjj+nsVYZDuYL8=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg

6.0.7-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 37 Beta)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

