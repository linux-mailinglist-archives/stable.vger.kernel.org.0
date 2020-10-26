Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C83298530
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 01:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1420962AbgJZAyn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Oct 2020 20:54:43 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:54037 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1420960AbgJZAyk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Oct 2020 20:54:40 -0400
Received: by mail-pj1-f48.google.com with SMTP id g16so2262838pjv.3;
        Sun, 25 Oct 2020 17:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=5WFCJezsdW5InvoJ5ci2QDi2UOmYLen9tQ8gYVcpN3w=;
        b=uY6GYjSLa/x7I2N1wnxY/R7XS3AwDtn9ONMTegO6/SVOJPii+FlNPVfC07yfFBT9G9
         4T1cO6hdZpy6errCj0Wz96Ni/fXCRxnFhVYAac+0VFOLU24mmmhqlwyZqsUQ4UUIQeST
         T4kMaUEt+CJNQhKnd1Q59dJRsZcXkuCKt5wVI6X0XfemSAluFKy3FAFr0pkcInrEIs3+
         UwMwj8Fm0gPYN7T0vL2DsQmov7xPxFItn8PJ3kgd2+PqXVpX7AV3shPUI4JPRZnjg4oN
         Iyrp71wHXXiCYXLwQyQ5TmmjLeRzyHLJhFR7tgtwpS6Jsb+frmoi7N94G/JWi77CCY1D
         EyUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:in-reply-to
         :message-id:references:user-agent:mime-version;
        bh=5WFCJezsdW5InvoJ5ci2QDi2UOmYLen9tQ8gYVcpN3w=;
        b=QkKPn72oN6hmKG4y3e8Ct0sVtqNZ9jQ2b68FrLQwI/75EYOVn7YFMCbty6SA22FdYV
         YJBLcmpXKhXTvXvSfOO6x4wr+KBiQa6uajQsz2b+UM6shGVJ+IK1mbtMk+ypOSEIRedq
         1v0oZoXcBEZZVLcmdPTesySuy+UsmnBvRB9rDGI79LdqisN3LkBh+6Qpe4peSEX7l7D5
         S8vexO5FIgoGBwqygktzozWJbsWfHmcrx2Plye1IH+/JmTEb/XxHnZL8i/PzA3FqMizT
         2K/KrgVsgqfCtSRjHnrSyq9I5NMe6cBmuiBVnawxkVL2PyDsQe7yqsa0UcqdpFYwLcTE
         eyTg==
X-Gm-Message-State: AOAM530fKB5Rhf2BYDebGIpYB7X/hBJnKeUVGVxYaqUbgE6jAN+FW+Q/
        WlljSoXyRtIqFlxkgjHMRXYsLsvXcNJgfHgC
X-Google-Smtp-Source: ABdhPJwOjGkDOWw09MNgFCbTFwod9DQo+B7tryt8PatrYPSmJN6dGKhNdfyYXW/hpB0BG8uGobRSIg==
X-Received: by 2002:a17:90a:2a01:: with SMTP id i1mr10753161pjd.54.1603673679380;
        Sun, 25 Oct 2020 17:54:39 -0700 (PDT)
Received: from darkskies.za.net ([2601:647:4b00:9968:1e4b:d6ff:feba:b9ef])
        by smtp.gmail.com with ESMTPSA id p19sm9749184pfn.204.2020.10.25.17.54.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2020 17:54:38 -0700 (PDT)
Sender: Norman Rasmussen <normanr@gmail.com>
Received: from norman (helo=localhost)
        by darkskies.za.net with local-esmtp (Exim 4.92)
        (envelope-from <norman@rasmussen.co.za>)
        id 1kWqmR-0000Pe-O8; Sun, 25 Oct 2020 17:54:36 -0700
Date:   Sun, 25 Oct 2020 17:54:35 -0700 (PDT)
From:   Norman Rasmussen <norman@rasmussen.co.za>
X-X-Sender: norman@darkflame.darkskies.za.net
To:     Sean Young <sean@mess.org>
cc:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 053/125] media: gpio-ir-tx: improve precision of
 transmitted signal due to scheduling
In-Reply-To: <20200902125101.GA12378@gofer.mess.org>
Message-ID: <alpine.DEB.2.21.2010241744490.21269@darkflame.darkskies.za.net>
References: <20200901150934.576210879@linuxfoundation.org> <20200901150937.150292200@linuxfoundation.org> <20200902102521.GC3765@duo.ucw.cz> <20200902125101.GA12378@gofer.mess.org>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463809279-370925855-1603673675=:21269"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463809279-370925855-1603673675=:21269
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8BIT

Hi Sean,

On Wed, 2 Sep 2020, Sean Young wrote:

> Hi Pavel,
>
> On Wed, Sep 02, 2020 at 12:25:21PM +0200, Pavel Machek wrote:
>> Hi!
>>>
>>> [ Upstream commit ea8912b788f8144e7d32ee61e5ccba45424bef83 ]
>>>
>>> usleep_range() may take longer than the max argument due to scheduling,
>>> especially under load. This is causing random errors in the transmitted
>>> IR. Remove the usleep_range() in favour of busy-looping with udelay().
>>>
>>> Signed-off-by: Sean Young <sean@mess.org>
>>
>> I don't believe this should be in stable.
>>
>> Yes, it probably fixes someone's remote control.
>>
>> It also introduces > half a second (!) with interrupts disabled
>> (according to the code comments), which will break other devices on
>> the system.
>
> Yes, I've always been uncomfortable with this code, but nothing else I
> tried worked.
>
> BTW the delay has a maximum of half a second, but the point stands of
> course.
>
>> Less intrusive solutions should be explored, first. Like.. if that
>> part is time-critical, perhaps it should set itself at realtime
>> priority, so that scheduler has motivation to schedule it at the right
>> times?
>
> That is an interesting idea, I'll explore that.
>

Did you try anything around this? It looks like it might be required for 
devices like the raspbetty pi zero w (see more details below).

Is there a way to temporarily increase the priority of the existing 
thread? or is the preferred way to do readtime priority with a dedicated 
thread? Assuming the latter: What's the preferred way to transfer data & 
control from the user's thread to the dedicated thread and back? I'd 
guess some sort of queue or mailbox?

>> Perhaps usleep_range should be delta, delta+1?
>
> I'm pretty sure I tried that and it didn't work. I'll give it another go.
>

Shouldn't max actually be less than delta? Otherwise the code is 
indicating that it's okay to sleep for longer than delta + rescheduling 
overhead.

I tried your latest patch ("re-introduce sleeping for periods of > 50us") 
on my Pi Zero W and the post-usleep "remaining" delta is anywhere between 
-25,500us and -50us (i.e. usleep_range usually oversleeps!).

The upstream patch gives very stable results: post-udelay delta is 
typically <10us (i.e. it's underdelaying just a tiny bit).

I tried adding a module_param to tune the sleep threshold buffer but 
because typical delays are 500us and 1,500us and the worst usleep overruns 
are way larger than that, effectively I had to set it so that usleep never 
triggered

I even tried usleep_range(0, delta - buffer), but that produced the same 
behaviour. (I even saw a post-usleep delta of -125,000us once!)

I added a call to switch to the FIFO scheduler at priority 50 (the same 
as the recently proposed sched_set_fifo function would do), and (as long 
as ir-ctl is run as root) it brings the post-usleep delta to ~500us (or 
with usleep_range(0, ...) for large deltas the post-usleep delta was 
between ~500us and ~5000us - still undersleeping and very acceptable).

Note that pwm-ir-tx has the same issue and so should probably get the same 
fixes (when they're figured out what they'll be).

>> Perhaps udelay makes sense to use for more than 10usec?
>
> I don't follow -- what are you suggesting here?
>
> So any other ideas here would be very welcome. I'm happy to explore options,
> so far under load the output is can be total garbage if you're unlucky.
>
>
> Thanks,
>
> Sean
>
>
>>
>> Best regards,
>> 										Pavel
>>
>>> @@ -87,13 +87,8 @@ static int gpio_ir_tx(struct rc_dev *dev, unsigned int *txbuf,
>>>  			// space
>>>  			edge = ktime_add_us(edge, txbuf[i]);
>>>  			delta = ktime_us_delta(edge, ktime_get());
>>> -			if (delta > 10) {
>>> -				spin_unlock_irqrestore(&gpio_ir->lock, flags);
>>> -				usleep_range(delta, delta + 10);
>>> -				spin_lock_irqsave(&gpio_ir->lock, flags);
>>> -			} else if (delta > 0) {
>>> +			if (delta > 0)
>>>  				udelay(delta);
>>> -			}
>>>  		} else {
>>>  			// pulse
>>>  			ktime_t last = ktime_add_us(edge, txbuf[i]);
>>> --
>>> 2.25.1
>>>
>>>
>>
>> --
>> (english) http://www.livejournal.com/~pavelmachek
>> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>
>
>

-- 
- Norman Rasmussen
 - Email: norman@rasmussen.co.za
 - Home page: http://norman.rasmussen.co.za/
---1463809279-370925855-1603673675=:21269--
