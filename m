Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3147531C3C
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiEWTTC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 15:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiEWTSj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 15:18:39 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24CC4102754;
        Mon, 23 May 2022 11:53:41 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id rs12so18994402ejb.13;
        Mon, 23 May 2022 11:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=2ZCytUAOk/pwtZMG0E9kDBiBIfg7JhM/yV+MzcZ70mQ=;
        b=NI/JfXS1L2wh4cJIiAKkRxgD/lBjQdoqhzs3WtDHs/U+plYwHdMvx8dm0DmByDGMsr
         Z1igtZ1XLfQmGMybQ2Uwt8l/g2Ecla/nFnTX+/xteStQUt6OMiL/1Al5f4rbUp/uFwcJ
         enh8IGEpRTv3I30wUz8u8KKpBEmQDV8+6TXZyQB5S2uY/W5UF1zj91F/gRR+wWX/352R
         bEiXKIc9h8xs90J02meMvClExc+hzEEVvl7m3PDN7eRLa5/ufB3hWmj/HZyYHcq4jyYg
         Hn2QKlWWP96bFrOFwPKGNJWbfdKRr+/OJSVH0HLU2o2FiEWP/xIt+MGef4X7QpUF5wc/
         y/jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=2ZCytUAOk/pwtZMG0E9kDBiBIfg7JhM/yV+MzcZ70mQ=;
        b=InaMt/XTK4ybS2InPxVfwQRHbOY35dYeQWobbeMmSIw9YmiXRJjtJo4RsHz/XRzbIE
         C3kpOMCAYjVTQcu28NEAXlkPskK3M3Dv0CPbz1VTYsIKtACbObYnPvwk7dN+7FCcF57b
         EzL9nW54XjNnP+9+954QLm/L5AACLCi2LDw2Ij9FnkhuEo5sHI5vEy1AHM/MyccPLTHp
         A6yeZkemPUS+Afsec2lD4l49mlpd5BSog0sayaF1nmsPtmukfwi2dIXFLKVfTs1LZlDX
         HK+VrfqCPuglgK7zhZH1eQMl4t6ykQ1Si+DKO5pBO8v6Eq7H9+FKKfOpzv7S4RoLQ0Ki
         2yqA==
X-Gm-Message-State: AOAM532JL9u5DkY0yoG9vIFKOPr/Iu7a4K9/XsmJLEzIvef7bmiv/t6q
        y7QIJFRSit5RxLEIOn50c75hzbnNE3ly50xteR0=
X-Google-Smtp-Source: ABdhPJzq7ECdMNaNpe0qi+bNZ0NjNDyJx6bQY7R/ckcsux4ZSYoEZPUXFsn9urmaxAiTzHYAGf18eDVcOWspllDpHhg=
X-Received: by 2002:a17:907:3ea5:b0:6fe:ce25:7a69 with SMTP id
 hs37-20020a1709073ea500b006fece257a69mr7803508ejc.626.1653332019476; Mon, 23
 May 2022 11:53:39 -0700 (PDT)
MIME-Version: 1.0
From:   Fabio Estevam <festevam@gmail.com>
Date:   Mon, 23 May 2022 15:53:30 -0300
Message-ID: <CAOMZO5CsGxwos0_SwSEACZxSUVwPeT7GiwzT8W+sV=o=b=i-Mw@mail.gmail.com>
Subject: goodix: Commit for 5.4 stable inclusion
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     dmastykin@astralinux.ru,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        stable <stable@vger.kernel.org>, linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I would like to kindly request the inclusion of commit 24ef83f6e31d
("Input: goodix - fix spurious key release events") to the 5.4 stable
tree.

It fixes the spurious touches reported on an imx6dl board with Goodix
GT911 running kernel 5.4.

Thanks,

Fabio Estevam
