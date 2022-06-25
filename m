Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 931ED55AB6B
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 18:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232883AbiFYQFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jun 2022 12:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233242AbiFYQFi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jun 2022 12:05:38 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F092167F3
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 09:05:38 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id r66so5155253pgr.2
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 09:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=ph19z67WWj8MKbdbfJ/X9NXE3OtaIRjlRTh0jWTZhVY=;
        b=H4h0XMDxFCq5boqjcJg3XuOOrzXroWG2+z15aYOxu1pjqtbmYZXPWVso0t0OWRY79w
         +aVkcrtq+y709i4jisRh6C+SH32enEioYBhiFnUphHzfw1kgJdO1NXdZzK1nHlOyZ4bG
         8tg8UJu/o5/A795qp+B5QJ0clnBDDLUwIFFbj+nIPed1kkcNMzO/99bTExAbaqpgxM/h
         qUzPieSABg4uXifAyq6f2K1cfBzv7wGGtj2WOjcTwrB4iNv3LR9NxldnEhCoaY5IDdmU
         Fpr6GXx7EO0JBOSeOievT3I2hr8JrHAKtQahPwkkz+pKqQcSIRa7hqi+DGZYNXFPC9on
         o2wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=ph19z67WWj8MKbdbfJ/X9NXE3OtaIRjlRTh0jWTZhVY=;
        b=IXTwtkPhr5WZ2jMX7fqXwwyuQRUp2DinYYD0doyqxoeEhAmHEl3Sp+u9GGCE0dwsUz
         pWZ/dSrgtxtkToL2uM53DL9SSf2RTPPcijo4X0DB3YnMMbhCRBZkchETdk1ptsZiWHQQ
         bMxcDeldgOxvePjeWT9A9W7UsZJr282ero8peWCCx+ow2j7YIrRPW5JEOtJwa4SSbM3B
         v0RrV3KYxR1N6CTrZf7HEIe7Fyd+CIsS6EIWjl7YHBY0pgmgQxRcphe7TWFFe092kgO7
         6YsgVNVVem1go8TiLmsJmUCP1epEfToHjMg8qCiuN8PzcuiPpVCskqS9EqvK7ocKLxsN
         72BA==
X-Gm-Message-State: AJIora/2SF0te69gPkxPFlaGp8qrqVP/AKfz9HkbknVOKVnpUvsjF0/l
        pIXFEbsncljM7rnY5Zz1LC9zdzzE1esdaMfzjhQ=
X-Google-Smtp-Source: AGRyM1tpQkCFthbcGhOQVMXnavRFa0hER9WF7D4fCMYYzqN1kZgBqQ6utZeVN6t0lRUxnDOwLAfo3Nuregd/RZ/jGqo=
X-Received: by 2002:a05:6a00:1901:b0:4fa:fa9e:42e6 with SMTP id
 y1-20020a056a00190100b004fafa9e42e6mr4872936pfi.1.1656173137698; Sat, 25 Jun
 2022 09:05:37 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:90b:793:0:0:0:0 with HTTP; Sat, 25 Jun 2022 09:05:37
 -0700 (PDT)
Reply-To: josephkavin0111@gmail.com
From:   Joseph Kavin <malachietoby@gmail.com>
Date:   Sat, 25 Jun 2022 10:05:37 -0600
Message-ID: <CAPbc+v9tZgup0xsAc1k5xD0f+xZThwCcYTzxGtkPyhoWYDiw+A@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.0 required=5.0 tests=BAYES_50,BODY_SINGLE_WORD,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi   are you available to speak now

Thanks
