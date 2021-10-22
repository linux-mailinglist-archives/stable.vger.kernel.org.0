Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC86437A41
	for <lists+stable@lfdr.de>; Fri, 22 Oct 2021 17:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232921AbhJVPru (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Oct 2021 11:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbhJVPrs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Oct 2021 11:47:48 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E962DC061764
        for <stable@vger.kernel.org>; Fri, 22 Oct 2021 08:45:30 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id v20so2970514plo.7
        for <stable@vger.kernel.org>; Fri, 22 Oct 2021 08:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=jZEe3mSyN4QNyfmvjcpLf8zyGloN8fa7bOJ1mJUx1IbPXaIY+J51VXW9s9NA0I9d7q
         1E9poYbq7fZxRc4dsGmejdk5oiKHVU8xvwGTvZXD64z3NqpJMW5luCZRCM7qY6xuPX9D
         uh3LujlouzVoHiR+YU2pTMLckxua14dRxjqac2sAGm2tJ9qT2HjSCpK84eL2wZHngjrR
         9rjXPO/Fb3qPF8HZ+xkHunhZWxVxSE9I+hrY3pqrO4tnvssb4XOsKeR6Zm86ds1lRENl
         UTm1dsUPG736h9PmGd2ULdq7O0tARiLwmKAtIucYiljNT4wcFi2NmW4vz6pTnSDUnCap
         lPzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=5vuyrUBVpX5IYYPqgLwQAq7TXXzZ2O1NrultbcATR58WETeOd4KeUUOixeJEDG9lvD
         ZmDTooo/zUJm6T4ripg4f4gP5WGPjZ4qrjP8ltF6/csDVhNFdkglZBUiV21p/U8B/pHd
         RQHIff4X2MzfvbsaeEt+CTGEiR70mftOECQ9Auxv2Tkp/txO8bmwdX5uMg/9i5L+XIAm
         aqNLMLFHOri79i9Z0q6OytqrZAwpXi8Sv8XC0F5tQN+p6YBiNmlx5xwFEth3AqkNYxEE
         pMVBH8gHjkFqc/0wZgpbReue2PLjiabZ3V5ArMt4M17M+gf12Zed1exqkmvXXubkxCDP
         /k1w==
X-Gm-Message-State: AOAM531EZj1KvQW3Zj19cb4HLbmheQwrY/HOfLc1O7Y1+u9yYq1i7x34
        b/ftIuz0fPtYXjE9UfdSe55uxby3ivFJmsfYvz4=
X-Google-Smtp-Source: ABdhPJzlxY4SvTKl55xBoCBWtvFN1EFwEsAcSpmLeQBq1jXvA5CkL2vieGHjL97X1GciaM4QzLzPkmX+v2dx7Unl2p0=
X-Received: by 2002:a17:90a:1657:: with SMTP id x23mr795550pje.148.1634917530467;
 Fri, 22 Oct 2021 08:45:30 -0700 (PDT)
MIME-Version: 1.0
From:   Ben lussy <benlusy1988@gmail.com>
Date:   Fri, 22 Oct 2021 15:44:22 +0000
Message-ID: <CAP79b0F4XnR5-y8F-coqKM1LZHyXxfB0XxgE3jbQPT4AhUow7g@mail.gmail.com>
Subject: =?UTF-8?B?15nXp9eZ16jXqteZLCDXkNeg15kg16LXk9eZ15nXnyDXnteX15vXlCDXnNeq15LXldeR?=
        =?UTF-8?B?16og15TXk9eV15Ai15wg16nXnNeaLCDXlNeQ150g16fXmdeR15zXqiDXkNec15nXmiDXkNeqINeU154=?=
        =?UTF-8?B?15nXmdecINeU16jXkNep15XXnyDXqdec15k/INeR15HXqNeb15QsINeR16gg15HXnyDXnNeV16HXmS4=?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


