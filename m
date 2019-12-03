Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1FC112056
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbfLCXhv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 18:37:51 -0500
Received: from mail-wr1-f54.google.com ([209.85.221.54]:38429 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726653AbfLCXhv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Dec 2019 18:37:51 -0500
Received: by mail-wr1-f54.google.com with SMTP id y17so6219465wrh.5
        for <stable@vger.kernel.org>; Tue, 03 Dec 2019 15:37:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XNArJCVLTUii44OkzDLyVOCWdJvTZXM9By5hqHfNVuA=;
        b=LqGeMr48cG7jvG57jaHjKdq5EdpwBJ2/fLLxACful6TfelqzyC7nuEnpvBCoTvtN7Z
         Aj4yAomM47tN3JhCecMvxJGpr8mVrN3mWsw4xkFSReKm5v1VtZsoBUz/LZwAWfWqB+g3
         5CzQUmfb3cVu1f2w/9YK/ququxFU4nwkUYn3EXxYxU+QxxxlpVR3bZtg6EgZjFGi6ACx
         Ipo9qRPpBiOyAlUayacips8cIRildUYqzxrP11QaFieF8gjCVFIDY1FOuBvE0HKPQ/M7
         pUrriN0nxaj7aMt2IoyWn+TnVktBScc+YqH5SX6S+sOJxIZ9RUDyIj3LoLg6NfO3cuHd
         vFig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XNArJCVLTUii44OkzDLyVOCWdJvTZXM9By5hqHfNVuA=;
        b=Mm6z9oiDjReoqkbQkPfCSkOjXmKf9E+bG2dPseLzDoj8MDnYjW7cHX5WccPL3h3EyB
         oc0DWubXtJTsJlNMY+b4cu0hR5T7uAZO9h806ex23AGdqQy0EfeLADElwrXu3Phc0jrF
         +BAvIXnmB0XeL1sC44DfUEfsCKwAEdRwo30rEBnuMHlpNOSobjlC0sCdTC5rrZRmKE/9
         C5PL1CqjSdzUC1ChwEzC+pznuG0IJPESGMkNd4dSTHx4tJ2fetuxXf8JpR4LPkJARsFJ
         hUDOYx4ZW1Ian9jvDLeOze2A3MZ/3zsLez7WCQaPraVIXvlXilsAKtvuUMqATQ1xJ/CR
         CWUw==
X-Gm-Message-State: APjAAAXDyNQh1UupRvpsxyKUKlsYQ7WREOXvmOfyJK946E8iOycBXAad
        plwtUHzeij+UojjU3T7KuwYDMd1t/PYUQnkydaN2eQ==
X-Google-Smtp-Source: APXvYqzkegJSTflqiIY/mn6cQ2tcdTUaAkD46NQ4PbmgXBrs47LbgQ9RpeQKipPpoKeWInoG169t3j1hiY7zyQmsMaI=
X-Received: by 2002:adf:ff8a:: with SMTP id j10mr653621wrr.312.1575416268924;
 Tue, 03 Dec 2019 15:37:48 -0800 (PST)
MIME-Version: 1.0
References: <CAPtwhKrmvw8wm1u_36YEoLgQ8pGe=v5xaV2RN4W6jVw3zOgeQQ@mail.gmail.com>
 <20191203230944.GA3495297@kroah.com> <CAPtwhKpZCequxTMzAcVcJ34EW4AFqNDcWuoud-D3nywpYxzx5Q@mail.gmail.com>
 <CAPtwhKqiKZtTGO_7Jpx9nEDhQu8LESvaZth4uHb5a8Ur+=65SA@mail.gmail.com>
 <CAPtwhKrCY4ZWFPYsr5N3LcAJOJVStN9Qb93-zk+GFRNVsfGxgQ@mail.gmail.com> <CAPtwhKoMk+AY2D9Akoh_v4fSTj9JtUT1k+DQ_qcuK=zbZSdpgw@mail.gmail.com>
In-Reply-To: <CAPtwhKoMk+AY2D9Akoh_v4fSTj9JtUT1k+DQ_qcuK=zbZSdpgw@mail.gmail.com>
From:   Xuewei Zhang <xueweiz@google.com>
Date:   Tue, 3 Dec 2019 15:37:36 -0800
Message-ID: <CAPtwhKpjLswXm3fSZ6o0hiNxM2Zgj3zmfsLLPYtPpqmN91792g@mail.gmail.com>
Subject: Re: Request to backport 4929a4e6faa0 to stable tree
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

I sent the backports which should apply cleanly to the 5 stable kernel
versions: 4.19, 4.14, 4.9, 4.4, 3.16.

Does it work for you? Please let me know if I should submit them using
some other formats. Apologize ahead if my current format is wrong.

Best regards,
Xuewei
