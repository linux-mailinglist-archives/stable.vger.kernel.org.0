Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22165819F1
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 14:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbfHEMr3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 08:47:29 -0400
Received: from mail-lj1-f175.google.com ([209.85.208.175]:36736 "EHLO
        mail-lj1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726779AbfHEMr3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 08:47:29 -0400
Received: by mail-lj1-f175.google.com with SMTP id i21so79193779ljj.3;
        Mon, 05 Aug 2019 05:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lL3Croan3VsAvdmzwNDatZOL62bT4QU+D/MCPrex0oo=;
        b=ATyHGFdJW6t6n/bKqnHz3vFzUOhu9uNRejyoHdvgSqforsurcwCC756tzrgXgREw87
         uzun1aMWRKmX/60nRtpJTK0ndF3WqtcdWDIaY7qrpU3lMDpiz2ZNUklVpKXbpUptxLdN
         GvAtD7KmJYDy/p1bd1nYzcsTLvZUV1ZKxc0ty9bNjddv5oPOPWG2KBmOEIFs3FOFuxK/
         QWjcOyNeAl5PUBrDa0SAOtUEuqb1FXiIRXHKOMYl31P0Ug71jLbJuAWZXTg7uCRI2j8m
         bQmSfpsMr3azx3JIJfOX97A8CbpI7tnWPdp8mUjv9tG4lOfkStP+LdNVbzo3/+uejMcH
         EubQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lL3Croan3VsAvdmzwNDatZOL62bT4QU+D/MCPrex0oo=;
        b=tI3A4nZdYrbIC086QL1I2bj85FdBTpkugaEGY25X1Jzxaz+KYpgyAciL3SIdPB0r62
         kdctES6uVWPMOUvuq5Hamn4jAXHJPqrL3HqJnxiK7THYjQnrjx49unGVzZO6kBkYZgl7
         w32rMTBqSvs+fT9iknLilh9saR6blayQdxH8ex3ezZLwG4mqdEF6HSa603hJKafKLxJq
         9QihV9NkxtVwxR4aDttY9uEd3TdZZmZ4drFT1QZVU0fkpWBZhDO8FqMNqHiidSKEiaGx
         2uSWD+o16/NcYV5Vmzv0YUTWda/YBtly9ngnSstAlNd1AQnOXtK6am+Gyc6EQmUZCT+7
         +y/g==
X-Gm-Message-State: APjAAAURD3J+dWjptbHU0IuAl+yPQxxmJ+Fc9I555S04Qg00Xgh3/Yir
        D+m/8+VHEeMK3JGFAjKIBul3bfQqzRptutG1jy1Qeg==
X-Google-Smtp-Source: APXvYqw5b2HMbRc+Zic5cYzHfdzRa07AQdAGvaoc1hRPPEo2ULeTuY4WfOUW8G/0Du+E0E5QtbNjBPo8dRbPIXFb0w4=
X-Received: by 2002:a2e:8741:: with SMTP id q1mr25763713ljj.144.1565009246427;
 Mon, 05 Aug 2019 05:47:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190606185900.GA19937@kroah.com> <CANiq72n2E4Ue0MU5mWitSbsscizPQKML0QQx_DBwJVni+eWMHQ@mail.gmail.com>
 <4007272.nJfEYfeqza@devpool35> <CANiq72=T8nH3HHkYvWF+vPMscgwXki1Ugiq6C9PhVHJUHAwDYw@mail.gmail.com>
 <20190802103346.GA14255@kroah.com> <CANiq72kcZZwp2MRVF5Ls+drXCzVbCfZ7wZ8Y+rU93oGohVAGsQ@mail.gmail.com>
 <20190802112542.GA29534@kroah.com> <CANiq72mSLmP-EaOgY0m2qgTMVsAnyE6iuW5Kjdw5mSy1ZH0y-A@mail.gmail.com>
 <20190802155627.GB28398@kroah.com> <CANiq72k-2Gtb8Q_f2Nhy6aud-QwuSiJ8oEJbwt-pjd+bs8qDVg@mail.gmail.com>
 <20190805115540.GB8189@kroah.com>
In-Reply-To: <20190805115540.GB8189@kroah.com>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Mon, 5 Aug 2019 14:47:15 +0200
Message-ID: <CANiq72kUg_Q0VTju=ebs3mgTca1QtYvGt6AKCwS=TUoN3ENuYA@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_Linux_4=2E9=2E180_build_fails_with_gcc_9_and_=27cleanu?=
        =?UTF-8?Q?p=5Fmodule=27_specifies_less_restrictive_attribute_than_its_targ?=
        =?UTF-8?Q?et_=E2=80=A6?=
To:     Greg KH <greg@kroah.com>
Cc:     Rolf Eike Beer <eb@emlix.com>, stable@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 5, 2019 at 1:55 PM Greg KH <greg@kroah.com> wrote:
>
> I think I got it working now, all looks good for 4.9.y, 4.14.y and
> 4.19.y for gcc9 so far.  I'll leave 4.4.y alone :)

You are welcome! I am glad we can now use gcc 9 easily. I will be
keeping a look into gcc 10. :)

Cheers,
Miguel
