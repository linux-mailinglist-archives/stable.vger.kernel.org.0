Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07F7B36D9CA
	for <lists+stable@lfdr.de>; Wed, 28 Apr 2021 16:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238486AbhD1OrE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Apr 2021 10:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237669AbhD1OrD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Apr 2021 10:47:03 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF865C061573
        for <stable@vger.kernel.org>; Wed, 28 Apr 2021 07:46:18 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id j84so4553648ybj.9
        for <stable@vger.kernel.org>; Wed, 28 Apr 2021 07:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=h6OAgehpT04wot4wdcmj6UwWPkm0eVoCmff7gv8RNgE=;
        b=RfIIqie1eyQ6T3Btkkd2QnFS8Q6L7s8xjimO/Rl3KyEtkmsYIQQcmjRG58pS6XW8CT
         rR5kSeAfI6aSX9LL34AnSibEiP6KhqFe2tbG/SVRuF6xbNJ8MHq98HDUFpzdEnvgRAVc
         HDI7ULzS/AiQCMeh4mOMzSj8/G0wLnQfsO9GeKR97Rjg5s/YaUrq4WpdOvsJ+grSCM7O
         gH/LPSwvq4qXOJG7NXTt0gx6Qh7qxFWNNsUhIC2WxRFDGloNogoe1QZ/DD+FmHsQZ6US
         G0Ihl6CPVcyWrrw2bN+CLUHuUmCvd0rXfHeoMUGZgbwgSgFOX7nQ2q9/rW+CXkr6ISuJ
         xgYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=h6OAgehpT04wot4wdcmj6UwWPkm0eVoCmff7gv8RNgE=;
        b=lLO+hU/BN4ktnvIiq8fftCP3p9z6bguvQUpzX//B3x1vQWQB+0abySS3ibmp+mb3lL
         h3P0J9Ri7FygTQTFQVUIO7pa+ICFM14eKQSqSJoR/57jZEK5bi+rb5ghx+uWsxre3/+L
         LIkIVYQpVa+SjvssLmha9bSxeoip69uVHGCSL8S7B8AHkWmoRc7wUcwaRpo6mFgz/48T
         rk3llCfUcCTyRScDwuw46RjQurDe8ukQvu2Z5o1geWYpOxn+aleqSnO3+ffbdT0a/iTY
         QWysrevIQruwuWaEkLxnVDyz4vKbsI1LVjmqzsFoL+ch5GKo2nPWwayUAUraod25crzg
         cMTA==
X-Gm-Message-State: AOAM533ozEtiHPh5l12KOmvW//ZQdxAnA3pLaIaPDPS7vAGukvB9S/Pd
        RJA+mOtg/P64YbGU/cwX1Z/J2z+6R9BcVaKaJos=
X-Google-Smtp-Source: ABdhPJzIH4NzKH4+/4+eFxPugseJLIJf4I1ggpQBkLgNw7nwdJxBcuGFd2Syu7RRWbaJKpCGuw1tcTOUyowtErxt6Ek=
X-Received: by 2002:a25:6643:: with SMTP id z3mr12003263ybm.165.1619621178078;
 Wed, 28 Apr 2021 07:46:18 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7010:430b:b029:ab:634b:a435 with HTTP; Wed, 28 Apr 2021
 07:46:17 -0700 (PDT)
Reply-To: davidbojana20@gmail.com
From:   davidbojana <aadia084@gmail.com>
Date:   Wed, 28 Apr 2021 14:46:17 +0000
Message-ID: <CAA-c2iVP_Fuf7ipYhDKhPeC32Moyo6P--WFJWh9y=Yz-dpUMQQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

0JfQtNGA0LDQstC10LnRgtC1LCDQm9GO0LHQtdC30L3QviDQuCDQuNC90YTQvtGA0LzQuNGA0LDQ
vNC1LCDRh9C1INGC0L7Qt9C4INC40LzQtdC50LssINC60L7QudGC0L4g0LUg0LTQvtGB0YLQuNCz
0L3QsNC7INC00L4NCtCy0LDRiNCw0YLQsCDQv9C+0YnQtdC90YHQutCwINC60LDRgtCw0Y8gVmVu
dGVzIGltbcOpZGlhdGVzICg3NTAwMDAwLDAwICQpLCBkaXNwb25pYmxlcyBlbg0KbcOqbWUgdGVt
cHMsIGRhbnMgbGUgY2FzIGRlIENhcmxvLCBwb3VyIGxhIHByZW1pw6hyZSBmb2lzLCBJbHMgZG9p
dmVudA0KYXZvaXIgcmVtcGxpIHVuZSBzw6lyaWUgZGUgZGVtYW5kZXMgc291cyBsYSBmb3JtZSBk
J3VuZSBjYXRhc3Ryb3BoZS4NCkF1eCBmaW5zIGR1IHByw6lzZW50IHLDqGdsZW1lbnQsIGxlcyDD
iXRhdHMgbWVtYnJlcyBzZSBjb21tdW5pcXVlbnQNCm11dHVlbGxlbWVudCBsZXMgZnJhaXMgZXhw
b3PDqXMgZGFucyBsZSBjYWRyZSBkZSBsJ29ww6lyYXRpb24uIEF1eCBmaW5zDQpkdSBwcsOpc2Vu
dCByw6hnbGVtZW50LCBsZXMgaW5mb3JtYXRpb25zIHN1aXZhbnRlcyBzb250IGFqb3V0w6llcyBh
dQ0KcHLDqXNlbnQgcsOoZ2xlbWVudCwgZW4gcGx1cyBkZXMgaW5mb3JtYXRpb25zIGNvbnRlbnVl
cyBkYW5zIGxlIHByw6lzZW50DQpyw6hnbGVtZW50IChjaS1hcHLDqHMgZMOpbm9tbcOpZXMgImxl
cyBzdWl2YW50ZXMiKToNCg==
