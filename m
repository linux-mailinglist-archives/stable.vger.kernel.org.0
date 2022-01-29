Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0AF44A3177
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 20:06:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233167AbiA2TGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 14:06:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbiA2TGD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 14:06:03 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F5BC061714;
        Sat, 29 Jan 2022 11:06:03 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id f17so17376110wrx.1;
        Sat, 29 Jan 2022 11:06:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=vGOIKVbh4iovxY7LJMwHsA2lSYxNofF0261lZCp+qAI=;
        b=jctWj74RJoh+z8moLx/ah8lHqDwgTn99l+OrGj9EmfIZP5+Jc72+39+gKPPLvQq/9s
         yJOZ0LGVXVao0UFZEaJ9DI1u99N8tO+MZ5gESkvb/+wZ6wdUK8bMY/NN7joBfOdGoPAS
         7pb5P9nriDlh+9dnwP1f3sI5bSzdarBmxVdEwpc7M+o37eprN0q9Ao9k2WJOCCHUcOgk
         5bJT2beBqw/bNd9w3CUbly3xCQ6hcK2AgE7slv1ddAHgdcKbtD5R5+5LBJQjZ7g0ibdN
         Kcf4d/Q76CzuJABtv+y4tXGONOB5h/NXxFilj+Hgcbp9FyxI5MgxaCQS2qRkrUF+0bJV
         N9pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=vGOIKVbh4iovxY7LJMwHsA2lSYxNofF0261lZCp+qAI=;
        b=ZdV/E1DgXvfkE0yaMY8O5Uf+XBJrGhwfDm9rIcdneF/8w1ybXX4vQPIis37L5OPAog
         fzR7IGmDfj2ba4xJzCDIlWak8XIrMlfQwWTpTp+Dr01tM4nK9e8wPk5iZbWIyCm0/RYq
         M87DgINne5JwkiTs7ZvBfi/tgm/KtWRRLiZCg3M/uuIAE2gThmHIjLS9GinA8V/1x8TN
         zJz9DLxzJS05j2GDHQUlfUoAjfaCKaX8daNFXbyS+stAVak3HP5JjagQczLNGARixZXM
         PnZ4yi5mqRH8Z8v/XxEN/T1on8VW2nVv5cr1NyqLNlVDrx5eoY+gSjQwj9e/BIhaLnq7
         COJg==
X-Gm-Message-State: AOAM532/0H/uYsk3yxTNy2yCo4H1RhoVC5wKO4fK+viAPWaw72gpbGll
        u3EPsLKFa5Tk2RS82NBoqu8Oa4ywZbuE5FaAwKYJU7e+B7Y=
X-Google-Smtp-Source: ABdhPJxD2BNti5t9mWljHgog2DJluWwkSP49sdtte1juUMrh4ZEZQRr6aDn3kZZQDQGp5GUUhhoj4ITQYmQo+Qn/3M8=
X-Received: by 2002:adf:ea02:: with SMTP id q2mr11514123wrm.455.1643483161035;
 Sat, 29 Jan 2022 11:06:01 -0800 (PST)
MIME-Version: 1.0
From:   Felipe Contreras <felipe.contreras@gmail.com>
Date:   Sat, 29 Jan 2022 13:05:50 -0600
Message-ID: <CAMP44s2vAmfHU+h5bSp5FJvks7T+b_tpdU1U4pBvK9jFF6C=eQ@mail.gmail.com>
Subject: Regression in 5.16.3 with mt7921e
To:     Linux stable <stable@vger.kernel.org>,
        Linux wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

I've always had trouble with this driver in my Asus Zephyrus laptop,
but I was able to use it eventually, that's until 5.16.3 landed.

This version completely broke it. I'm unable to bring the interface
up, no matter what I try.

Before, sometimes I was able to make the chip work by suspending the
laptop, but in 5.16.3 the machine doesn't wake up (which is probably
another issue).

Reverting back to 5.16.2 makes it work.

Let me know if you need more information, or if you would like me to
bisect the issue.

Cheers.

-- 
Felipe Contreras
