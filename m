Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B41E04245EA
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 20:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231633AbhJFSWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 14:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbhJFSWV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 14:22:21 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B80E6C061746
        for <stable@vger.kernel.org>; Wed,  6 Oct 2021 11:20:28 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id j5so14083799lfg.8
        for <stable@vger.kernel.org>; Wed, 06 Oct 2021 11:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=6BBz1x23DsjwhAhhb/P0xsyqDhfM2pEQpa9nGnmhgR4=;
        b=XVV8Ip2vsIHk0X40arSl8LX95K8I3DW6rSUFStxfNCUa2tnrZblK+71XlTtLHMW7SE
         ZdUm3cJcFj0sTMOE6guZAQU9cDrnPRaWDHiQ/XUKVG+B0FMYnH1PlX1g0xlipQY/27QQ
         KkE5P1xDBnvJ34I6R7rchdiKL82/irziBxT1kWZBr5jc57905g3/BfT3zV/+uQMcu+JJ
         wObB/6peGmoZzKJKmGhhVFw7PQ0GXfm0pd3ZwPS5Iozf6Y5jiNwZANoowvvtu9ITxAeu
         VsXKB3+fKveLCsilyZ4/ZmXJdP+wo/cakfYOLWby3QEPRJdZq9/9/mZ5kmTG7EF2kIw1
         rXJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=6BBz1x23DsjwhAhhb/P0xsyqDhfM2pEQpa9nGnmhgR4=;
        b=z1R1gE8ZCXHXmTyg6IaknCPYBME0awgdL0sC+7LXr9tSuAPFDxgtXJz7aa5lmB1i5R
         kMsKvJbwm0C7Net7CUecavMhfsTJQx44L0AVgcvhdjf9COVGmBd2DNL2KhXuCM0/ZGBK
         m71yAp7Djbg1PkJF+9tpyn8rJiC9N2taZuj96fz4SkMbhPriANHWKneZZM1rkqKvUawW
         IbhVFqDvY+uF4XV2YEc5z/w8VYZZW93dy33C1VSTJjmvOAyhKjk3T5U7DNnsdFmHN15q
         j5R0/iQLgR7AlQrdkypt0tiS+NxpGPwPm+cXFQu+VG90fnrJmyHxpZZGthgDArN5BiII
         ff0g==
X-Gm-Message-State: AOAM530wRxwpix26qbxdszQyG+mthuf+v2ZLKkjV/AQ+cqttLTzlE1PV
        LiYCRg6kJLS7R8IcJPMnzIIuqiZWhj7pHqbAsi4=
X-Google-Smtp-Source: ABdhPJyrV8u5U9LMFy1QBgVUhzwp3jaLsxYNhjCCcTl7V7arusFTQ3Xj2SXzNjiKaPY3LOd4Fdl+Y8rm835GY2BgDh8=
X-Received: by 2002:a05:651c:3ce:: with SMTP id f14mr9523851ljp.90.1633544427045;
 Wed, 06 Oct 2021 11:20:27 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a2e:1407:0:0:0:0:0 with HTTP; Wed, 6 Oct 2021 11:20:26 -0700 (PDT)
Reply-To: mrjoshuakunte@gmail.com
From:   Mr Joshua Kunte <mrjoshuakunte23@gmail.com>
Date:   Wed, 6 Oct 2021 19:20:26 +0100
Message-ID: <CAE8KSLzgpmdDBfoP21vUX4LOYL6H_BhS=aOgT2RXz4da1Cyd+Q@mail.gmail.com>
Subject: =?UTF-8?B?0JTQvtCx0YDRi9C5INC00LXQvdGM?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

LS0gDQrQk9C00LUt0YLQviDQvdCwINC/0YDQvtGI0LvQvtC5INC90LXQtNC10LvQtSDQstCw0Lwg
0LHRi9C70L4g0L7RgtC/0YDQsNCy0LvQtdC90L4g0L/QuNGB0YzQvNC+INGBINC+0LbQuNC00LDQ
vdC40LXQvA0K0L/QvtC70YPRh9C40Lsg0L7RgiDQstCw0YEg0L/QtdGA0LXQvdCw0YHRgtGA0L7Q
udC60YMg0L/QvtGH0YLRiywg0L3Qviwg0Log0LzQvtC10LzRgyDRg9C00LjQstC70LXQvdC40Y4s
INCy0Ysg0YLQsNC6INC4INC90LUg0L7RgtCy0LXRgtC40LvQuC4NCtCf0L7QttCw0LvRg9C50YHR
gtCwLCDQvtGC0LLQtdGC0YzRgtC1INC90LAg0LTQsNC70YzQvdC10LnRiNC40LUg0L7QsdGK0Y/R
gdC90LXQvdC40Y8uDQoNCtChINGD0LLQsNC20LXQvdC40LXQvCwNCtCc0LjRgdGC0LXRgCDQlNC2
0L7RiNGD0LAg0JrRg9C90YLQtS4NCg==
