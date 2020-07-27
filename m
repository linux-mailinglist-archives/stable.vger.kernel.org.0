Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7E522F6C2
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 19:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731308AbgG0Rf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 13:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgG0Rf5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jul 2020 13:35:57 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F207FC061794;
        Mon, 27 Jul 2020 10:35:56 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id by13so12724205edb.11;
        Mon, 27 Jul 2020 10:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p1Xxzh8BKyi7YaAKwS75pk1cn5R3z0KYffzpM3lBakA=;
        b=UHw+OFNwhntQ/NKue9aAmiAKtwUHhmdr7crLAGFyOLY2RCDy+rDHg0F6Z1JABOWZlX
         hmyDJkKCVLuFmZtUBPC0IWya3w1Fbu/JGsk3NlrTxSMdofqJtcVsCppyqDapArJoU7Ki
         2qLdsvYPGFL72O3OzoyxPZzX3yXEeSNTb/QZFHy7Gkuseh0fWitxQjii7eKUtQPbYowQ
         jfnHRvLRbEXMABPSNptWeHpoeqotUgCSyqIqWD2KXvr3yrVwUFrDpZWyQQd08z29CLrZ
         QYGrFbJduwbNJAsg7i642oju0Td9/Edfk4F3iyTafd0MC25JT5TEueAW9zLTy4JX2eYn
         eUEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p1Xxzh8BKyi7YaAKwS75pk1cn5R3z0KYffzpM3lBakA=;
        b=KHUgtLwiB6kmW+ZeRRO6M51JR+P59Xk4hF1TO5TglN4HKIeW702HsEw9zEdD7/lpYu
         fRcOXl57xl5bjl7yJ8m/t5o0P702/DAV0UkTCECedQNTyygiv4s2U/yYGEq4/rMRoGSs
         hojGIdeAFEJTXwJidhom/RJ6lJm/LhBizOdH8qKr41sCb28pd9ls7n5k9Ihxua52kgwQ
         ycF+VaWaUXPjGJF3Gbma/8al0zD6NAmLnXP0KexyTWNdEMbKu3mc+oY7sE0cXDmOfwaE
         ISKgeUVjGTextPHsIt5qxzwkv91GfoBVuzN4hdVRWVohC052+MWFTb0XOvB6zRiwWiOj
         w8Xg==
X-Gm-Message-State: AOAM530yeducfa4T7t/V8hS4B/uSf2rkkL1xqOl+66Cfx2w8rC0Sikn6
        iBq2ehxWMXhnBwBs7GZT36pwP8fhXqFXrmlupEKz+x22
X-Google-Smtp-Source: ABdhPJxknfe6DNivTeDFirexpnHigiu/5+o5wWBuquCQQMkATKzsdtDkBUJUIk63s0W99C4LeILg3lQD19F6EuCqOJY=
X-Received: by 2002:a05:6402:1716:: with SMTP id y22mr15426756edu.301.1595871355585;
 Mon, 27 Jul 2020 10:35:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200703225043.387769-1-martin.blumenstingl@googlemail.com> <9de38c5f-6fdb-5fc0-3fd3-bec42b8807a2@synopsys.com>
In-Reply-To: <9de38c5f-6fdb-5fc0-3fd3-bec42b8807a2@synopsys.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Mon, 27 Jul 2020 19:35:44 +0200
Message-ID: <CAFBinCCzRF3XFMwDC7EhMYR=ydhbyYkXVSK7o6kuTg=7B_HngQ@mail.gmail.com>
Subject: Re: [PATCH for-5.8 v2] usb: dwc2: Add missing cleanups when
 usb_add_gadget_udc() fails
To:     Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "marex@denx.de" <marex@denx.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Minas,

On Sun, Jul 26, 2020 at 12:04 PM Minas Harutyunyan
<Minas.Harutyunyan@synopsys.com> wrote:
[...]
> Kernel test robot found issue:
>  >> warning: unused label 'error_debugfs' [-Wunused-label]
>     error_debugfs:
>     ^~~~~~~~~~~~~~
>     1 warning generated.
>
> So, 'error_debugfs:' label should be under #if/#endif:
>
> #if IS_ENABLED(CONFIG_USB_DWC2_PERIPHERAL) || \
>          IS_ENABLED(CONFIG_USB_DWC2_DUAL_ROLE)
> error_debugfs:
> #endif /* CONFIG_USB_DWC2_PERIPHERAL || CONFIG_USB_DWC2_DUAL_ROLE */
>
> Or you have other suggestion?
unfortunately I have no better idea

> Could you please fix this issue and submit new version of patch.
I'm going to cover everything I add inside the same #if (not just the
error label).
if any additional label is added (above) in the future then the code
that I'm adding must not be executed when that #if evaluates to false

v3 is coming in the next few minutes.


Best regards,
Martin
