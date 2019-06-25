Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 397DE551A8
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 16:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728620AbfFYO15 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 10:27:57 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50394 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727070AbfFYO15 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jun 2019 10:27:57 -0400
Received: by mail-wm1-f65.google.com with SMTP id c66so3088578wmf.0
        for <stable@vger.kernel.org>; Tue, 25 Jun 2019 07:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+9etwd10XsmAJnvvS9UuAn9fwPZcTjdmb4DbhzUhzY4=;
        b=dETPRulQady/L6OTKvrsAUgbch6CrFxoCMjFfxBU0A18BaAaXg8MraoL3x7iBfZJav
         txwhLgjLx0C0bFGfnSmtIE26yfHR/sGAuLnU+vMNJoHaQLKrCzeUvKIeRDHHQJ0XZ+DW
         rk60PxnVQhiXkpkLKHKnuJCrKLVlv653wkvjIqOHELeZ7uQcuBBUADpzlwsDBnycS8Pk
         PQsWJtOvAKh7XuNB0sfvHkdVCX2jPevtG06X9tZq4E/KKGfC/c0lAWF2HfD2tyvO1VxI
         OaqEfYNgor/Vb4FizzdT/GrAdznUaklTuhZifQepFRIXGG+WmKqI5zhpupOYprV28Q3g
         QoUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+9etwd10XsmAJnvvS9UuAn9fwPZcTjdmb4DbhzUhzY4=;
        b=ch1gmoL2+Io0JZo/ysPrOLkAsqHolYsSlZl82VjPHfJSaEo6VMbyyW0UV+hDT98KgT
         6sx9jMWQoSUg0PLQ4FleQok92MJoVsIPdyvgsHrbjYzAvQrIwmef1VtmfJ8wksjLu8Ax
         MVYbxLDsBNwE6xK7ltMGl1wbCilWpXheXkLL6sdY+0wQngLzPXvWbZrKSk43BOOMZA/z
         LZH8BZFgPnhQzllZ57a4uPNRb4CVPsJmgGFUcV29j0laMy9ulLiUB5Alfp0Zl8bPg7Gd
         1fOfLZ1VD3dXdBXlPbJu+41mH/hTOizXzpEW5veECmYvwkRnUOK25JEgK9NcO+wnJX5A
         xY2A==
X-Gm-Message-State: APjAAAU/mEhckolsNGjObNHHS5zNNKw4ga75tDE3Jb/hSB641VtQbOcq
        5s7beRC6tf6kyMyvbpxxoNugVFSraKgydBzt/Ciyew==
X-Google-Smtp-Source: APXvYqxBgNeJUj+mXDTJUV7ykl6CYkTF9HhIAeUNNnmOePbatnFv/DlbZn9ERdtDbN0aHkCIKQIB/J8OhuT7BuYUuGw=
X-Received: by 2002:a1c:b457:: with SMTP id d84mr21576064wmf.153.1561472875447;
 Tue, 25 Jun 2019 07:27:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190625141725.26220-1-jinpuwang@gmail.com> <20190625141725.26220-2-jinpuwang@gmail.com>
 <20190625142444.GA6993@lst.de>
In-Reply-To: <20190625142444.GA6993@lst.de>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Tue, 25 Jun 2019 16:27:44 +0200
Message-ID: <CAMGffEmDt91QfOtbBm2AsRgb0JHW5pzOQeC_7TdX_v3XrW40qA@mail.gmail.com>
Subject: Re: [stable-4.14 1/2] block: add a lower-level bio_add_page interface
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jack Wang <jinpuwang@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        sashal@kernel.org, stable <stable@vger.kernel.org>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 25, 2019 at 4:25 PM Christoph Hellwig <hch@lst.de> wrote:
>
> Why does this patch warrant a stable backport?
[jwang: cherry pick to 4.14, requred for next patch to build] :)
