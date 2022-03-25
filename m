Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2624F4E7930
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 17:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376913AbiCYQrX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 12:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376881AbiCYQrW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 12:47:22 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B0CABB08B;
        Fri, 25 Mar 2022 09:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1648226746;
        bh=Y4weAWtXL6C5HMwkvGlahO2StI7dkL/CTmBwMw5J+U8=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=ftxeo+vkDIe/VIf0mnjDpOEd/YTJRyBMqAPNS7jjW3/YnTIBmYEXjAov7n3vv5zN2
         SLOb4YGTaHSPWCjBhCv5LIIwTUZwsjlpp4ILcM8lzJRDVp2afAd2mg2tFkKIcEIOFT
         A53HnMZiUnMvV52b0vmEV7ys1DC5WzOpBKBtjfjI=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.33.236]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MbzuB-1o3q691bfL-00daZ0; Fri, 25
 Mar 2022 17:45:46 +0100
Message-ID: <67e05375-077f-ebc7-c691-b0a0a31b3479@gmx.de>
Date:   Fri, 25 Mar 2022 17:45:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 5.17 00/39] 5.17.1-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:9tup9ZxgFss6Bt1mZT5gIdKan7fZ5o+bgIi4AwwM9CsgpdOZ1es
 POGTrPvRYvcyKgKcsrjN0r+rQvqzEXsmgWIQQNO7RejobHGIbQiLmNGoAispMb2tHS4j4EK
 WKCEtYog9Ah9uyiETpIO0JOU0i0fLK0OXW7WU6aPEerFSXPzY0JBcE5J4unxk5fXdtQPaA0
 N4H+RXfHiq9TcGJULTXEw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:skJvsuPxlMw=:mrdiOPgLCXrYpY0imMZZhu
 4mlv/6VUiqwjt4g8Xv0xEMlvDEDBTrfkmSEQ3ZXfQNVZVaRVoVqjPnSZEdRjadd/Vh/VuRVw5
 sXNMXpQaGQ1JgVBqOx/YL1B26doNmr8eE4JuniBSyiJ+cxvO8eKcN3AqoGKYUe3sEnHD+6yoV
 4xUtHcCoDC72B1OgNkYEjtByWaKlm5VKWwXdUjMjbYDeGpNuGKA6NxbBXJsTvdUOMAxCffhqm
 WRqrYre+67cYJIhcG49WT5M2/AbOP5OW9h5RpnsHqzrubnIHKZXgjiHXbvn1+HCg2O8CR5/pg
 BjPOUu51akcfrvQ7bZ4iko6+Q+43GcUy7QXmNvyYMBQCeyhysK0Zes5RC17dVSkv76yQUPSKX
 mKIG41ndG07B7BJaR7LKStWPW5bxMBayKhZikNQgZgnVn5wK39nXQmLYXh6oJ1v1hWDeUNYQd
 bHSvjHGBqhK4rZ0YDsEtfqE0JNMBxw/UAPQlFKGc31V8SSYuKFZaeY1TDjvCX2ycawTVfHUZP
 RcEe/b3SG1jH7+YyFNsCQx7eCAedkCTOcJTatn/H3bLWeJKjUZAcY+QYPsWJm6/V34LKxkCcb
 wUH/zA4kTxbH5FReL7TFFFnoLGFvtO/4oN3mQepZw44537lrXeMBVsu8gfJEfsGe6ORsNrpsK
 z0vW1HpKSzasevZ+G18hanbQWoWCKcNbd5TovnFPn5Ch8W+uG415k9NMN/a92xV6mQHaZkFkd
 o38uWPkVg5B1w/PHa1ptX/s9dlbbHFZCZbp14tJDKn9lHDplerzu+8aiHNLjhRG4KBF4ZfOGq
 Hie1a9MsYxuM4xo6HeqTebYn8xwtzYBze74YOYe5dVJy2zG1sIlCLDWutfCmwNeswj0LT+h9R
 JAOD9al43/2GTUnoIM6Fq85cqP6YfZIwSXAII+urhLjBYNxVX+XOknzfQEmyDmdCqKEZ6UzGO
 mQe3+g60Xig/no1QqgJka+MEJm1DuvxQWfuWLnjYA31MtloKzGGr6a5UhJsnYLY/CGnEg9IT9
 BE5kr+aoBzYXXSHt5bwWVHKXETA7J0KnS0LCjQ/ZpafVew78iF7idd5r60p9VZY+iWAL+Xgtr
 AAJB65hnzDymQM=
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FAKE_REPLY_A1,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hallo Greg

5.17.1-rc1

compiles, boots and runs on my x86_64
(Intel i5-11400, Fedora 35)

btw I get:

iwlwifi 0000:00:14.3: Direct firmware load for
iwlwifi-QuZ-a0-hr-b0-69.ucode failed with error -2

(not a regression in the 5.17-series, but compared to 5.16.x !)


Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
Ronald
