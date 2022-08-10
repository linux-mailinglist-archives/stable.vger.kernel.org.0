Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6085158EA87
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 12:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbiHJKjy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 06:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231373AbiHJKju (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 06:39:50 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F7917E303
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 03:39:49 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id r5so11768666iod.10
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 03:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc;
        bh=2te+YOLOSvIbf1P44CshbYr6tZq0kyrnNrRQW3VLo40=;
        b=bMLn18D3kEex09M2jB+UvTRqQHrd9NTICJr1UtlrJKK5rM3m8qYWa7GdvLLa52YMBf
         AMRqcxeZj4tExdoTsNYrNAE6Tyzsh0WyV4oS0hb78YtHlj27oKaSjTb/VmNb9OMdEc4N
         9OT4ROywlDu2/GTHS9eYT9ukog+nIPiQHSgymXp7Sfo62kxK3RcPYJekXBF8Mqe+6/7l
         KBJJPsL92gBueh0vc57+KNOeSvU4ZoM2XRWtTCxbOx/GGVr4Xtvsh6IlfGVNdyPYiLCc
         BmWzssf7ThyffTghUjRuGUw4iDKz5TSh4tWfqWU2h6vLPjreUl2fyJagOBJYUXqDZI/7
         u29g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc;
        bh=2te+YOLOSvIbf1P44CshbYr6tZq0kyrnNrRQW3VLo40=;
        b=5fBCuudILhTzxKY6BJS0jwMxhO7lVQaQPNMNZRxxDC7LVdARmvBDrXTZl5RqNKYn14
         yi+8ygRxIkcBbR8xah0QtJm4v4V+iUQ7x16edN+bQQ5Am7tbZ3qOmXbDqQLxdra+CIoM
         hUPta0OP1H4YrMKczvU2PxvzUCXTSFO2sZunonZlK6BrddBnKPOxRr4VLi6+lKCa9622
         5fOaJ26Uh7to510R+whhgUn0tUriewWkH648iZyKisz169pZsViRKrXu6a08pLOoW4mn
         073NCiJUPzRF+s0kPoPNIdZcHP73qR6mHKhqIOjUDfiiqhFG2CL7RnStIpaPwbzy/SPl
         3w1A==
X-Gm-Message-State: ACgBeo2yeZOeuHF+hfjQUIhXANz0hiYE3k760FqphtY/GDo2OkndTwQg
        oBgYD+gQraW+cBK84azywUiS2CftfJubgWbsXy4=
X-Google-Smtp-Source: AA6agR4JPKE5uqPmnTgbcJS5p+Is7tW71v04xR7Z1VcIUsg1NqZghg9QgssaG3xqx/RD7ODJGHIxY++YjRXYF9grQ5g=
X-Received: by 2002:a6b:ba84:0:b0:67b:d73d:b15b with SMTP id
 k126-20020a6bba84000000b0067bd73db15bmr11290796iof.33.1660127989094; Wed, 10
 Aug 2022 03:39:49 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6638:1a95:b0:342:e995:7290 with HTTP; Wed, 10 Aug 2022
 03:39:48 -0700 (PDT)
Reply-To: georgebrown0004@gmail.com
From:   george brown <joeakaba00@gmail.com>
Date:   Wed, 10 Aug 2022 12:39:48 +0200
Message-ID: <CAEoXQLxAX=Q32ZNhRs2khRtfSgyHCE16U_Y+egdz0p7QRGgEeg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=4.5 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

0JfQtNGA0LDQstC+DQoNCtCc0L7RmNC1INC40LzQtSDRmNC1INCP0L7RgNGfINCR0YDQsNGD0L0g
0Lgg0L/QviDQt9Cw0L3QuNC80LDRmtGDINGB0LDQvCDQsNC00LLQvtC60LDRgi4g0JbQtdC70LjQ
vCDQtNCwINGC0Lgg0L/QvtC90YPQtNC40LwNCtC90LDRmNCx0LvQuNC20Lgg0YDQvtGS0LDRhtC4
INC80L7QsyDQutC70LjRmNC10L3RgtCwLiDQndCw0YHQu9C10ZLRg9GY0LXRgtC1INGB0YPQvNGD
ICg4LDUg0LzQuNC70LjQvtC90LAg0LTQvtC70LDRgNCwKQ0K0LTQvtC70LDRgNCwINC60L7RmNC4
INGY0LUg0LzQvtGYINC60LvQuNGY0LXQvdGCINC+0YHRgtCw0LLQuNC+INGDINCx0LDQvdGG0Lgg
0L/RgNC1INC90LXQs9C+INGI0YLQviDRmNC1INGD0LzRgNC+Lg0KDQrQnNC+0Zgg0LrQu9C40ZjQ
tdC90YIg0ZjQtSDQtNGA0LbQsNCy0ZnQsNC90LjQvSDQstCw0YjQtSDQt9C10LzRmdC1INC60L7R
mNC4INGY0LUg0L/QvtCz0LjQvdGD0L4g0YMg0YHQsNC+0LHRgNCw0ZvQsNGY0L3QvtGYDQrQvdC1
0YHRgNC10ZvQuCDRgdCwINGB0LLQvtGY0L7QvCDRgdGD0L/RgNGD0LPQvtC8Lg0K0Lgg0ZjQtdC0
0LjQvdC4INGB0LjQvS4g0ZjQsCDRm9GDINC40LzQsNGC0Lgg0L/RgNCw0LLQviDQvdCwIDUwJSDQ
vtC0INGD0LrRg9C/0L3QvtCzINGE0L7QvdC00LAsINC00L7QuiA1MCUNCtCR0YPQtNC4INC30LAg
0YLQtdCx0LUNCtCa0L7QvdGC0LDQutGC0LjRgNCw0ZjRgtC1INC80L7RmNGDINC/0YDQuNCy0LDR
gtC90YMg0LUt0L/QvtGI0YLRgyDQt9CwINCy0LjRiNC1INC40L3RhNC+0YDQvNCw0YbQuNGY0LA6
DQrQs9C10L7RgNCz0LXQsdGA0L7QstC9MDAwNEDQs9C80LDQuNC7LtGG0L7QvA0KDQrQpdCy0LDQ
u9CwINCy0LDQvCDQv9GD0L3QviDRg9C90LDQv9GA0LXQtCwNCtCzLiDQj9C+0YDRnyDQkdGA0LDR
g9C9LA0K
