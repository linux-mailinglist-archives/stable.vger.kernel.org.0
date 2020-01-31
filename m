Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 016A914E96B
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 09:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728077AbgAaIIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 03:08:15 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:36725 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728027AbgAaIIO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jan 2020 03:08:14 -0500
Received: by mail-lf1-f66.google.com with SMTP id f24so4231125lfh.3;
        Fri, 31 Jan 2020 00:08:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=DdiQpoauwZ0XveZynAvz0EuxVeGMQJtzs/ooDkpKNvU=;
        b=DzQ76bHrpu8+pQblpwwBPuNLdHXFIm0kNFIZiTjA+MjKRr8U4gAibdFiOqR9mL3S4V
         GkR+7CddV/m6XOVuuV9JIgz1+Q/INEnqKTGRM0a+nqPxzEZYXDL/gsL9EVaMsiNmMWnR
         ObfsKZOSb5uaI1euhJnHWAGbXBQ0SopAYbeP4X9UMSOjpgHA5KaGLDowN+9vD4I3GT1i
         KvsB2bznZbBDB8UfqEKkNFtGrog7frbs3mO0YEVHGwm0dXNugW3jJ5hnHUwAOdO6yLxQ
         MmRh9+BIFOMMxavFHLfzHlaK8EouEM0E3+RlDfl7BDRaYKr1lw3qZXJz2c5jP9gTH6wa
         anRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:in-reply-to:references
         :date:message-id:mime-version;
        bh=DdiQpoauwZ0XveZynAvz0EuxVeGMQJtzs/ooDkpKNvU=;
        b=f/a1BvCo+Hn0DYRePYBx9nP2UeyO4/+ECcU36T56/BrbJh3sb+u/xBudb16/7md03h
         3MYd88wFudshOY3SxTI6GjmQ1amu4wK/YkAHZNYz3YLmEdcUL4MG49cylmCzNzInUn9N
         F2pstCqTkYSB0xRaOFwIRCz9ATiSE+tZzvVvhhPVRa9U1BWoNSUjgEt6Eq4HSzx8lK6n
         0ICDBNqSzdhgekWEOsDmUU2UIxdH78mPMVU4VWka3cJoNbXZ0giT7T+rxugkNhvOYSsO
         OHkEEt8T725RntiUZKGCRi+J7oAUdqTMuxBUAvVpozI4EbL7Al7TckKKKjWlbYh60mbE
         2gTA==
X-Gm-Message-State: APjAAAWQAKBuQoOMDcred2oXUjg8l3s7V9dLxqunpSCq9oWGRi5wffJ7
        7Rc5ta81hhx8TxbIWtZdCk1ASSg2Dqa/Ow==
X-Google-Smtp-Source: APXvYqxshHjWAsmzOJGT3Cf0C4+PzkGUFCvYcshZZNADr4m7aryuqd8CyXyTGv4kUPWu++OT8wAtsQ==
X-Received: by 2002:a05:6512:78:: with SMTP id i24mr4844576lfo.10.1580458092287;
        Fri, 31 Jan 2020 00:08:12 -0800 (PST)
Received: from saruman (88-113-215-33.elisa-laajakaista.fi. [88.113.215.33])
        by smtp.gmail.com with ESMTPSA id d24sm4103880lfl.58.2020.01.31.00.08.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 31 Jan 2020 00:08:11 -0800 (PST)
From:   Felipe Balbi <balbi@kernel.org>
To:     Jack Pham <jackp@codeaurora.org>,
        Tejas Joglekar <Tejas.Joglekar@synopsys.com>
Cc:     linux-usb@vger.kernel.org, John Youn <John.Youn@synopsys.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] usb: dwc3: gadget: Fix logical condition
In-Reply-To: <20200131032501.GA10078@jackp-linux.qualcomm.com>
References: <cedf287bd185a5cbe31095d74e75b392f6c5263d.1573624581.git.joglekar@synopsys.com> <20200131032501.GA10078@jackp-linux.qualcomm.com>
Date:   Fri, 31 Jan 2020 10:07:57 +0200
Message-ID: <87a76482w2.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Hi,

Jack Pham <jackp@codeaurora.org> writes:
> Hi Tejas & Felipe,
>
> On Wed, Nov 13, 2019 at 11:45:16AM +0530, Tejas Joglekar wrote:
>> This patch corrects the condition to kick the transfer without
>> giving back the requests when either request has remaining data
>> or when there are pending SGs. The && check was introduced during
>> spliting up the dwc3_gadget_ep_cleanup_completed_requests() function.
>>=20
>> Fixes: f38e35dd84e2 ("usb: dwc3: gadget: split dwc3_gadget_ep_cleanup_co=
mpleted_requests()")
>>=20
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Tejas Joglekar <joglekar@synopsys.com>
>> ---
>>  drivers/usb/dwc3/gadget.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>=20
>> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
>> index 86dc1db788a9..e07159e06f9a 100644
>> --- a/drivers/usb/dwc3/gadget.c
>> +++ b/drivers/usb/dwc3/gadget.c
>> @@ -2485,7 +2485,7 @@ static int dwc3_gadget_ep_cleanup_completed_reques=
t(struct dwc3_ep *dep,
>>=20=20
>>  	req->request.actual =3D req->request.length - req->remaining;
>>=20=20
>> -	if (!dwc3_gadget_ep_request_completed(req) &&
>> +	if (!dwc3_gadget_ep_request_completed(req) ||
>>  			req->num_pending_sgs) {
>>  		__dwc3_gadget_kick_transfer(dep);
>>  		goto out;
>
> Been staring at this for a while--I think I see a potential issue but
> not sure if it is or not.
>
> If this condition is true and causes an early return, the 'ret' value
> could be 0 which could allow the caller in cleanup_completed_requests()
> to continue looping over the started_list and calling
> cleanup_completed_request() again on the next req. But we just issued
> another START or UPDATE transfer command on the previous incomplete req
> and now the loop continued to try to reclaim the next TRB (and increment
> the dequeue pointer and whatnot) when it might actually be in progress.
>
> According to the code before f38e35dd84e2,
>
> 	list_for_each_entry_safe(req, tmp, &dep->started_list, list) {
>
> 	...
> 		if (!dwc3_gadget_ep_request_completed(req) ||
> 				req->num_pending_sgs) {
> 			__dwc3_gadget_kick_transfer(dep);
> 			break;
> 		}
>
> The 'goto out' used to be a 'break', which terminates the list loop. But
> with the refactored code, the loop can only terminate if 'ret' is
> non-zero.

ret is initialized properly by dwc3_gadget_ep_reclaim*(). That goto is
correct.

> I haven't seen any real issue with the code as-is yet, but was just
> wondering if the 'goto out' should be replaced with a return 1?

let us know if you find any problems

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIyBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAl4z4F8ACgkQzL64meEa
mQak0A/3d500IX3EHlRzhhzlXOaCvqvu9pr9CGFFf6EHRB9C/wHbStuLRL+SSriE
OzmCL1vDRUowej9I10ymCs9b57SyMRbrmBmAjCSUixAGlzAJjvIJZu+WC/ZuADAN
eQJ1foBlrvc1i2FtLj5jFDOaDLle+9z26AICwTXgIC+40sCYReKXh2wdXGhcB1jb
ZsL2v6th/h1mNokUKgpQvn5R78ZdyTtLmCepZUk1w9HMT65MwT4aFihO25QMbvwD
pr1p8p0P4Njf/+yzaSxDYaDkxTzW52/gpyKk46joAuwyGhyi+T4MaBYOf+lxPlrW
KoclWmcB4pRdQ6OisAQsv87XwQLvLV92C2s1PLebxcCzljpvO4rvFv7hJ/4GxLmp
nnLKYm/LApLjYGl1NnBIxAV2njjZa5WX90G4J0kfBGqyl435tFoZ04qAaVzrASqZ
6cdHamO5nU+UPSwig1Bgt5D/3//aUmpvJzhMFObWs5JSvSd23E5smEHUSK0pS8Lg
jcDSsypNV/4RRgv2hUb1wpNwV70vkuTMDLhGTsh50LoleHIP9lxYByEblYQIWY8j
pABCyLwla1/Tf2Bqe3ttwGfsvVvVv9ZvDbKUwRmcLXH+hDuurMMa39ZYOjRUWSug
5dmN0Re2cbQ+3ETBxIRmD73XPW393XTVvNF9aJlTTGhj8wH8ug==
=F62y
-----END PGP SIGNATURE-----
--=-=-=--
