Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB3C6DC7F1
	for <lists+stable@lfdr.de>; Mon, 10 Apr 2023 16:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjDJOjO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 10:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjDJOjN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 10:39:13 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA90830DA
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 07:39:10 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-54ee0b73e08so105261637b3.0
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 07:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681137550; x=1683729550;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gvMlQcySDfxEOdq1G7T5QDMwjaz332nBLqMl46l6kS0=;
        b=h+jOpG2SowP2aM9Y8mKqYCPwKc9zVAplpCH6WB10TMebvOo4KSv52tWzvbqbQ5eAH5
         NPJChzbknk7flvXqTruL47xr8O7nGV0qWnQJ1p5nv+p6CbAhliDUkXcJ4pBBJ5TV+6dr
         JhgP0IJM367WMn/Fju72DAFQc2tT0+7mISjafw9CEbm97UpjlxgGgWATDG0uAFlnR/q2
         SLS9jfG/oGoY9r57v2YzviRIVBnvkzh+MJ+gbiMBKmIY0wxh7kjx+qOQ22nNzK4LOA1I
         ghCCX23ISs+QT6XkqyTeWhgdLfVl5Lr2dqQldTfqAX/WzEXuMTu/3mdK49KGXYff/dpw
         8OrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681137550; x=1683729550;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gvMlQcySDfxEOdq1G7T5QDMwjaz332nBLqMl46l6kS0=;
        b=2RCHT+7eGq8MowcWNx4K0wuJE/1MYP+n4fM1uypBYkhVrPNhIudZueITIJdhKq6rg9
         RpaPkB1bg440nAKVqh8nrrISsUB60icaXhDKbdfxnT0hav8EPQqs64VvblNWVE0M9O8n
         LPeCUUjSfL5roJZQsAEpGVPrO3gc99lb/bNvQPLU800WkAlPG+SqU4nH9Xocei+/c9XL
         fYZGGwCXDbZchQOhq8r+tMhjvEV65Qdxlx+EHEfsYjFNdOuhGnUxClq/CKyiaF7bgaSH
         nb5jGOCXmjUC5mHX0YAQ2g8ZWUDtvvnL8ifwBRW9/7bHA9Ww07h2l5pmz2dkfoisNmXl
         Ftdg==
X-Gm-Message-State: AAQBX9f9Ie6iJN8YFfAD2tbIdwzVQrIUaOlmGBxopZYqpWCFh6k9Sbs+
        TVomvveqvxWRUY1Hi/hdpv141DsiyeUxKz0qgQQ=
X-Google-Smtp-Source: AKy350ahbCgomjtyXs5NKqobwOdlzhh0nU+X7wH1SkhWpyBGYUha6H9iarCqU9OlGppnXCmQivID90PgGrcB0YijhNs=
X-Received: by 2002:a81:a848:0:b0:54e:edf3:b48f with SMTP id
 f69-20020a81a848000000b0054eedf3b48fmr4234559ywh.5.1681137549770; Mon, 10 Apr
 2023 07:39:09 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7011:c169:b0:33e:c7d7:4f25 with HTTP; Mon, 10 Apr 2023
 07:39:09 -0700 (PDT)
Reply-To: sharharshalom@gmail.com
From:   Shahar shalom <keenjr73@gmail.com>
Date:   Mon, 10 Apr 2023 14:39:09 +0000
Message-ID: <CALbsTwffY0=1NpHRr_pKAp7Wj=t+_LEJeTZ+y=u8t0A-_MLvSg@mail.gmail.com>
Subject: =?UTF-8?B?5YaN5pyD?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=4.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

LS0gDQrkuIrlkajmn5DlgIvmmYLlgJnlr4TkuobkuIDlsIHpg7Xku7bntabkvaDvvIzmnJ/mnJsN
CuaUtuWIsOS9oOeahOWbnuS/oe+8jOS9huS7pOaIkempmuioneeahOaYr+S9oOW+nuS+huaykuac
ieiyu+W/g+WbnuWkjeOAgg0K6KuL5Zue5b6p6YCy5LiA5q2l55qE6Kej6YeL44CCDQoNCuiCheeE
tu+8jA0K5rKZ5ZOI54i+5bmz5a6JDQo=
