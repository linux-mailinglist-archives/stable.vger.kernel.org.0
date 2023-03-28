Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFD036CCDD2
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 01:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjC1XBi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 19:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjC1XBg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 19:01:36 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F0B5172B
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 16:01:36 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-5445009c26bso259927127b3.8
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 16:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680044495;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dLJLUyyDaylNME9DSo9IQjYOiS8ASFBQNBUqnXOETK8=;
        b=oZLZtPGkgx//NDkFfd1m0Y15s3Cr5gXQ6NuatnF23DcIHjYoGx4VIeCawsKTKcFloR
         AT2VgDZs6aH7IpbJ63Dbo9zIoxdaE4CEGSzq0ZG5kSRcLSRWM8MzYyFG/NaPGJa94CWY
         MQi7/Hx2GvZmUxmKDXyJft/mkBRnJxoJGQoP613DsUoblXWtMBlJFEdN5CJHwVNYacYq
         UOo1lzMI/O/6PMJqVMbOjtvzhkM0tzDgvgf8AHRldlbca8UKzBwX94j8dr58j4BNGl3Q
         hnyX/jM4Xoi+WXGkPAPkkRAnd2S+Y4Phr4ifyFo+7yNQFCQq060koHar61E/H4xMLxd1
         phiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680044495;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dLJLUyyDaylNME9DSo9IQjYOiS8ASFBQNBUqnXOETK8=;
        b=PTL8XVfKqbW5CZxTFu4l9fy0vsKCMrP3BO5RpCJ4AJAP/akSgXyhrQF0DnlyJq43B/
         1SILxdRnOtpnRDBBfAfH+Tf3Gbo7XMkxWJQnBHDPvu+aAP+/NHSygrhdLe2DbpzQMBTi
         RtGN+rTBy/sKLDFyOoQ72gHF92T5lqXPzhAccihuj8/n+2AMT6uYOb7NiKMF7uBrNiVF
         oAtb6GWmPE2PNZyF2WAuqF9AwnhxctplC54ERtnrPxc78oS3g/p231LnxgYeqv8UkSes
         jTomefbDuxIBMZ6RBaxLMEGAErgko6uOxhzzWAn1i0ZIi1j48ZscRzteQupaYPU9GDk4
         vAAw==
X-Gm-Message-State: AAQBX9flE6Iy/GJifCNPR0OMfKkJmaLXr2oqxY4vOjhEWAEqI5YY6iEJ
        qO5UfEHgT/TbKluBWE3ULH5v7KjVYbqwBSelEYVjtSExWXM65gJ5H88sJg==
X-Google-Smtp-Source: AKy350Ybrc1ilwbOF6J+x25Z/tfSxx6jq/i7/qB1f5Dy8mtex35A+LZeswAOXexcSEoLv7X7UhWX/hk5z2OvlpYtu1Y=
X-Received: by 2002:a81:c84a:0:b0:541:753d:32f9 with SMTP id
 k10-20020a81c84a000000b00541753d32f9mr8148852ywl.9.1680044495197; Tue, 28 Mar
 2023 16:01:35 -0700 (PDT)
MIME-Version: 1.0
References: <CANZXNgMFifsEAUjCOtQWwxbZRbSvEYZz_Bwc4zrU6esb3xYRLA@mail.gmail.com>
In-Reply-To: <CANZXNgMFifsEAUjCOtQWwxbZRbSvEYZz_Bwc4zrU6esb3xYRLA@mail.gmail.com>
From:   Nobel Barakat <nobelbarakat@google.com>
Date:   Tue, 28 Mar 2023 16:01:24 -0700
Message-ID: <CANZXNgPgFwPSgz1-bE-CfTu1bgPgjKQVw8d8SqydVZe61J_41g@mail.gmail.com>
Subject: Re: 5.10 Backport Request: ovl: fail on invalid uid/gid mapping at
 copy up
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sorry please ignore this, didn't realize the commit that introduced
this issue landed on 5.11.

On Tue, Mar 28, 2023 at 2:26=E2=80=AFPM Nobel Barakat <nobelbarakat@google.=
com> wrote:
>
> SUBJECT: ovl: fail on invalid uid/gid mapping at copy up
> COMMIT: 4f11ada10d0ad3fd53e2bd67806351de63a4f9c3
>
> Reason for request:
> This resolves CVE-2023-0386
>
> CVE context: https://nvd.nist.gov/vuln/detail/CVE-2023-0386
