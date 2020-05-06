Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F04E81C7D34
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 00:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729947AbgEFWWX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 18:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729811AbgEFWWW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 May 2020 18:22:22 -0400
Received: from mail-vk1-xa42.google.com (mail-vk1-xa42.google.com [IPv6:2607:f8b0:4864:20::a42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DFE1C061A0F
        for <stable@vger.kernel.org>; Wed,  6 May 2020 15:22:22 -0700 (PDT)
Received: by mail-vk1-xa42.google.com with SMTP id n207so981074vkf.8
        for <stable@vger.kernel.org>; Wed, 06 May 2020 15:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=UwB2fAP86kABixdOFxvFJtm8iK8iJhNxo/5OP6piKDq6I96ZyJ1u6nMTfR03OHdml0
         NJvHhpiyv+JDKaCiAy5C8BIdLwLzyCC45hjyVKqtrbPOJYajmm/jJxu3W30lz76pWTti
         VW67zKG/MHQklkpyZhRHDvGFYGJECg8Jwc5u+1isYUEpB1frxjCY6skzflECXrBQ8ZrO
         jqPlg458hvuhqVtz2Y9HGA113q3VwGnM+TXU3pwOgLy0Sw0YdzUQA2s5RF26Cx873uyq
         M2en3cCTeFQPbumLqhFBAY6Bg0kaNQ0Bpwzs7WAqi/sXW+jWGlKO+E6VO8imjgh9DKHZ
         wb0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=IMEQfUAoYQlB0d/IYWvX0i7/nkjw5CH8ORkWFCH+B07lg/+x4PgAoY+khnEfQA0A4K
         NmiSZzvSqd+WhHSaDFOey+iSLkSQ7vzRg0TN1LxHujyDHN87qDAYio9u9BnYtmaHxzLj
         FsRaReLDat51X5WuuABUkUUaDJx+DQ3WiLIReqTUDKed75KcSz43Re/C1d7e15Gm2B6a
         b4txy/luRY00q1aF9cJ6ccaKlRrXd+EKWTI12keJ8pmLfRsQ4g9LLQDxhFFE20qN0//E
         v+Mu/Hbo0FMJkZztvlOkjQQKJTniEuhMoPo3pOrOyKqvFxFMUdmtx6yFbDz4MYAk7rcU
         5YoA==
X-Gm-Message-State: AGi0PuZA1yFdfdVC37Tc/tXhbQ52F8VBepj7yicBdSk54cCnpNsuU/0I
        P2OBzjiHDufL7hPewX/q9iO24fqdfUdPo5F0GnQ=
X-Google-Smtp-Source: APiQypLFpWfp0dH6TX37ZkiRjx2pDVyDlx5dtzq/yqkOHP5rp+5QgpYowqwXYH4ZnuasK86JfDILrL9WUr1AMd9jj2U=
X-Received: by 2002:a1f:8fc1:: with SMTP id r184mr9132970vkd.12.1588803741900;
 Wed, 06 May 2020 15:22:21 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab0:5e6f:0:0:0:0:0 with HTTP; Wed, 6 May 2020 15:22:21 -0700 (PDT)
Reply-To: sylviarobinson.usa@hotmail.com
From:   Sylvia Robinson <ekonambroise.tg@gmail.com>
Date:   Wed, 6 May 2020 22:22:21 +0000
Message-ID: <CAJRNscwdcjca0QV3cy+KAm5Jvu-=Zy28xnwJGpvZXOocy2+k9w@mail.gmail.com>
Subject: =?UTF-8?B?V2l0YWosIGN6eSB3aWR6aWHFgmXFmyBtb2rEhSB3aWFkb21vxZvEhywga3TDs3LEhSBjaQ==?=
        =?UTF-8?B?IHd5c8WCYcWCZW0/?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


