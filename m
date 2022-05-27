Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C05C535EF7
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238157AbiE0LJd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232852AbiE0LJc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:09:32 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218411059DC;
        Fri, 27 May 2022 04:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1653649768;
        bh=LXvhbb1TDZmpuAdxq+zNy5DrHla/6ICyoxOl9PNrOE4=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=Ie6pu8Zq95Pdjva3A0Ga4TtvkqnXyAb9Xrzptfx6/nA/IpendMAe5QZnUd619zFGL
         OV2O7WZXVgYgnt6dRZ045WiFk4nno3qe1DfLcGyBwCEIS6TGrbkYZr1TVWN54ni+Ql
         arc3FJ8Oh3H98YrUJoaHLEfViHrr3BTs4lohNBUE=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.34.80]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MKsnP-1oFnaX1ceD-00LCEV; Fri, 27
 May 2022 13:09:28 +0200
Message-ID: <e61d1f3e-2532-6ab4-81cb-9e1a6649df3b@gmx.de>
Date:   Fri, 27 May 2022 13:09:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 5.18 00/47] 5.18.1-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:AksC5+mhqQN8QJmHMcL9f3NL6aYX8wFlkwlv+y6G6PRfbpWiyUa
 Blwlhw4SA+OOItxht0X4BNjGL+MoVsLP4Kgmd3CuDxM1SRmB2cGHgiExOsY0YpLf0vFUGTp
 GBLfUB6Kjxy3oxGLv+Zc3YGOkxTP0Xmi0Bq3LP1ETMFlvvxIC1NwrPRHa4ial030/cb3iXE
 gYkX7SMl46WvpZa24elpg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:mFXXk9TO+8c=:OQPL8XnleFFknKFcxj0T5k
 yljc62Cwa5gYgiimMVKhd4W8GxOAgrrx6J7x1+ghr9pMwzH0LDKsYO7TjXS+bcLT5ABW9HlwY
 7KqTzdu+ONJMdJ+zQrcA65G/w83NYCs7U997Yq4al+MKo43YK/Ss9py8Ltab/OP/TJftkVU38
 kfFNii4KB6dp0BAmVHvJRv0iTPl7EfK/o4hmqj+/Zk+07gLW1qoRCkcrTxVswPgHYvXFBdnXT
 WtDXwXrJOJj6A4056GdQ/JWBc8MarI+/4S0SMp0CUxai99oVqIOo7NkNI11opkKVaZ4KHj2cE
 D8jCkK3zkXhNa8PLna7pE2MysKqlYfEZWBQy9bnHGD4YH0yjvBBNUEqq91CdyXYUD+P5Snh6o
 qzaqblwdLch+vdR350ASI/IoesRN94v5pW6m1v+yDlzE835CmfvI/AvvFEyuO0VGYh3wShXaw
 xuxztyzMqNo1u9ZHeFkNfNzy2evNE1z6du717Guyfjrgr7K605Mt2EKqfqhz89bxy2YsDYmLZ
 8IJhNTGI7e9H16ZbAPLIZvvqSWwWIByPW82WAO9NHRxL8CZkyE61Izss/WKrQgS0izv8EZd3v
 x8ytfNeB1onib2nJjjmNytBUAavoOqlMkC9X5pF3P8uW2f1vQfAgH19U5aD9F/71sK9bGRwxa
 aY1Zj8DuaAR3T7dr1NAuAAKVSKUOVDzmuBZ4g9F61/0bxxbP4AO7EUEWkV91RS6/ZjqqSHxZv
 WGo9lE7BIyLEpQEnhH9xLhGqQlh7jUCWxHjP9hpgSMVbtLg00K3IfeIUGVRK0T/Fa08J7LB9V
 jE8hLbul7kOP5Naff/M+wIgtfLywC5c8KkDV26IaQWY484UYrQCtf04LwSiPliGHwsw3eqqvB
 hcpNGttvHble1svqK8FCma4ngtGTgVt4hRfM7Llw+z2T2RhMSzMpRyxQjYqCYoxaIFRMPbiYC
 qNTzsaxeT9bZ43CqTEkmmC7DZ52tl/cLvK68yvXjfjK+c46FmFyJH75yoqqnDXF7mGjgl6KLx
 b9LhWxY12P2A9S1SYdBJqAMdwvPQ8zL90noU40Y3ylbc6jNHxcA+u1slo51nywtSTU3MfO2Pj
 mXKWuhcmPqnVq9XSag/4qu22jhMY4fn/IOF
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

5.18.1-rc1

compiles [1], boots and runs here on x86_64
(Intel i5-11400, Fedora 36)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de


[1]
not without similar warnings I mentioned here:

https://marc.info/?l=linux-kernel&m=165333405018563&w=4

Ronald

