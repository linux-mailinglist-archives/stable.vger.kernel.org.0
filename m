Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30CFA196FB0
	for <lists+stable@lfdr.de>; Sun, 29 Mar 2020 21:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728426AbgC2TX3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Mar 2020 15:23:29 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:43573 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727370AbgC2TX3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Mar 2020 15:23:29 -0400
Received: by mail-ed1-f65.google.com with SMTP id bd14so18194711edb.10
        for <stable@vger.kernel.org>; Sun, 29 Mar 2020 12:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yCEaYqYrzJerGx52eNsVBav4b4H9eXC/TPK77ClDmEw=;
        b=ekx8Wq4zzaCqiC0SnRmZlxiRv8FlmDa5SnfKpAlz0JQPuCAQxV4H+gkSnVXfuk7vAj
         AF8lobCRpkk9GNcZFUywEakgWyEXgwFJVvbFLO0Goeek13x7GAS/myrEWbvpL7V+FgT7
         vHDsNiq34bKGoLbc2fRLW8f5bTphm5WgpbzIQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yCEaYqYrzJerGx52eNsVBav4b4H9eXC/TPK77ClDmEw=;
        b=IQ1emeWXfFO8W3iuaEaG398LG8XOPaSG0+h7lYVULYHK0AuFrAZkHNhT8mmFy3Ou+P
         0FGGx7FuDOjuflcE2jGewdvL5CsZ9QQo2RI7YCpFOMO+fCZIUY143LIIw2sUMmOGJtVY
         1Sg4psCKYMTfTLCsSXioy1X5aiMTl8bfu989rRIqy+kRNbtHuv4qre/3+ttIf9pzv6g4
         w3grb5Eyy6cwrawlcu3tgRMKFY75lQjso67zDoJafGI4qiKdPP2LfDR+5tOm5kt5AIOF
         ffwoKVC1qyFyBmzSMGYJ8Xx3pWNbDrhBe971jFHadT9JkyoSntb7Veit01aoP5ceD9oP
         sIpw==
X-Gm-Message-State: ANhLgQ38p3qBpa9U8dUqdgbdd59SvmQCq95NBXw4SiLxdiZXbWN8N1I+
        r6pEnqNQ5Ri8ZgCp2VdA2Z0a/2YdwtE=
X-Google-Smtp-Source: ADFU+vvTsRPeq4/gnerXPH4ls/htYp56PaYv3qZApMkDFyZrQFYTM+Lml57vYSurKrIoKwnpFmmqEg==
X-Received: by 2002:a17:907:2062:: with SMTP id qp2mr7814619ejb.10.1585509805067;
        Sun, 29 Mar 2020 12:23:25 -0700 (PDT)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com. [209.85.221.52])
        by smtp.gmail.com with ESMTPSA id y17sm518326ejg.35.2020.03.29.12.23.24
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Mar 2020 12:23:24 -0700 (PDT)
Received: by mail-wr1-f52.google.com with SMTP id 65so18460589wrl.1
        for <stable@vger.kernel.org>; Sun, 29 Mar 2020 12:23:24 -0700 (PDT)
X-Received: by 2002:a19:7f96:: with SMTP id a144mr5973478lfd.31.1585509337850;
 Sun, 29 Mar 2020 12:15:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200328191456.4fc0b9ca86780f26c122399e@linux-foundation.org>
 <20200329021719.MBKzW0xSl%akpm@linux-foundation.org> <CAHk-=wgs1mfvk8pwefSD2A4=RgH6td50x9D-yn3Axm7icp5Xag@mail.gmail.com>
 <b80d7cea-a8f7-11c9-66fa-bdc272bdf099@redhat.com> <CAHk-=wg+UUK7hj9xKhoDfqXG4bCrOtTA-_WPoFemU_=1G_NHGQ@mail.gmail.com>
 <a8b2f031-05d3-d0cb-be12-7eb4ef316289@redhat.com>
In-Reply-To: <a8b2f031-05d3-d0cb-be12-7eb4ef316289@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 29 Mar 2020 12:15:21 -0700
X-Gmail-Original-Message-ID: <CAHk-=whVmAHBq7757cc-_7LeSCBRV+HjpBv-E56vAftk_fGRXg@mail.gmail.com>
Message-ID: <CAHk-=whVmAHBq7757cc-_7LeSCBRV+HjpBv-E56vAftk_fGRXg@mail.gmail.com>
Subject: Re: [patch 2/5] drivers/base/memory.c: indicate all memory blocks as removable
To:     David Hildenbrand <david@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Karel Zak <kzak@redhat.com>, Linux-MM <linux-mm@kvack.org>,
        Michal Hocko <mhocko@kernel.org>,
        Michal Hocko <mhocko@suse.com>, mm-commits@vger.kernel.org,
        ndfont@gmail.com, pbadari@us.ibm.com,
        Rafael Wysocki <rafael@kernel.org>, rcj@linux.vnet.ibm.com,
        stable <stable@vger.kernel.org>, steve.scargall@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 29, 2020 at 12:11 PM David Hildenbrand <david@redhat.com> wrote:
>
> Again, sorry for the trouble, I suspect bad mailing infrastructure that
> has been fixed. Will pay attention if this starts happening again, and
> then switch to another mail server/mail address, because something
> within RH mailing infrastructure is making our life more difficult than
> it should be.

Ok, thanks. Fingers crossed that it's all behind us,

               Linus
