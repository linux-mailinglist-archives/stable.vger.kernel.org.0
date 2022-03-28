Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69F624E9FD0
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 21:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245709AbiC1Tfd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 15:35:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233677AbiC1Tfc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 15:35:32 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D288B879
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 12:33:49 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id b24so18124382edu.10
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 12:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sweetwater-ai.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=s2M900Emm0RUOiV1ogG3lg9k6hVkpbhv3jnpCB8mBrg=;
        b=6UYgy07k79Hz/sg+jRRtRCwlo3lW/4dA5asr6W2ogl+PUF//wS5FAdaGiPr8Nq090D
         tfLRUaReJNI4oy3GCESb8Ph5OhaF9ecW3faOHvAMs1k+FgCWNPjFW9ninxBnuSjA8Pn0
         CA7rP3Jwqz8tIqcGpLrscYmY41vuJM8BOWpPbBYYDG5PvDtlud3WXb9ZBentHvNxfnYx
         WLOqMHKG3P1hkgfa48RHzKcq7p/Xp83gbFt+XjLT2b235wHkjV0AZn3cNQyl40Zk1E90
         BtULoWflbiQCpmcwBIuCDOXsfEpiL+vb/wagO7RiRxkxtTuJUIi3R+5L1iC0w8a6IiiL
         7TCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=s2M900Emm0RUOiV1ogG3lg9k6hVkpbhv3jnpCB8mBrg=;
        b=kCzrBHtXobYfdKStIntzg8L4d0baYEe/m7ABbvLM+OnK8DKM2/aDgYHjAgOACyW9jz
         yMh5aLKWRjQAb8UPtVZG0gGtXB0CGnLdBXHZb8Vy6OyCmVHDn/+pgmCWNftkuLA3Wkgr
         wLG7ybOqEG8yGccZNYrjn+C+lvNLcHuCRkLFZb5BEhmvBZfHCPHw6kO6bX1wTDf89rLp
         03lUZZt6f9XANCX7BXLlSqm76FjaiTmGTtBLw3Di7SkPU1SiUy9ojDz5EYDPuAxXVYLs
         b8zYW3Mw1xfTKPB9Zt4FWgTFn1S2bqmoO5t5KKUxlIM2bKRuC1ieFfX7m9YpHOy0ihBL
         UxnQ==
X-Gm-Message-State: AOAM531nnjpuxephXhPBPyRxus3G/zhCqy0neU9YP3oKYXsJPgeG3oP3
        OEoZzgeg1aoZ/7k6rtItFPM8AYYqzqV+iZJ+laymAw==
X-Google-Smtp-Source: ABdhPJwTYkdZHVLgzE2i0z6bzQgcUbBPdyjUYesjOdnH7y4IB5VpGlAalx4zA85oDzJBODMUVVsSTQWFGqE0XJknfuo=
X-Received: by 2002:a50:fb05:0:b0:419:2600:e439 with SMTP id
 d5-20020a50fb05000000b004192600e439mr18215380edq.71.1648496027345; Mon, 28
 Mar 2022 12:33:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220328111828.1554086-1-sashal@kernel.org> <20220328111828.1554086-16-sashal@kernel.org>
 <CAOnCY6RUN+CSwjsD6Vg-MDi7ERAj2kKLorMLGp1jE8dTZ+3cpQ@mail.gmail.com>
In-Reply-To: <CAOnCY6RUN+CSwjsD6Vg-MDi7ERAj2kKLorMLGp1jE8dTZ+3cpQ@mail.gmail.com>
From:   Michael Brooks <m@sweetwater.ai>
Date:   Mon, 28 Mar 2022 12:33:36 -0700
Message-ID: <CAOnCY6S6X7VQe3UaWWfgDJ1ST_CSe4UuVdcF5DqiPW2DUWDhKA@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.17 16/43] random: use computational hash for
 entropy extraction
To:     Sasha Levin <sashal@kernel.org>
Cc:     Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Biggers <ebiggers@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I should have said 'predicate', not 'axiom'.  Please review the
rigorous proof of correctness as listed on my github.  Another issue
I'd like to bring up in 5.17 is the apparent lack of mathematical
proofs and overuse of the word "entropy" when we should be using the
word uniqueness  - do we really want to go live with something that
isn't documented at all and just trust the word of any one individual?

My team put together mathematical proof of correctness, the onerious
of proving a defect in the implementation is up to individuals who run
the code and observe a failing - that is the point of code review.
The proposed changes to the pool means it no longer needs to be
"drained" or "accumulated", however we still may need a lock to make
sure the /dev/random device driver is ready for use prior to access.
Although I am actually not entirely convinced that this lock is needed
because it directly impacts boot time because of KSLR.  We could lock
and wait for the slow long term storage to wake up and feed us the
seed - but is that really necessary?  The alternate_rand() function in
the provided patch should be sufficient for the vast majority of
non-paranoid users, I don't see how a would-be adversary could
undermine this construction - sure it isn't ideally secure as a fully
loaded keypool - but it's good enough to thwart a memory corruption
exploit.  A fast boot option is preferable IMHO.

Regards,
Mike

On Mon, Mar 28, 2022 at 9:16 AM Michael Brooks <m@sweetwater.ai> wrote:
>
> Jason,
>
> I think this is an astute observation - the current design of the pool ha=
s this defect of being emptied leading to deadlocks, and in addition, acces=
s to it undermines the predictability of the pool.  This needs to be fundam=
entally addressed.
>
> What if access to the pool could never undermine the predictability of th=
e pool state?  If this axiom holds, then there would never be a reason to k=
eep a global counter for how much =E2=80=9Centropy=E2=80=9D or uniqueness i=
s in the pool - and that would remove the lock that handle_irq_event_percpu=
() is fighting over... which creates a condition where one lock is being ba=
ttled over by every irq event - which is made worse as the machine has addi=
tional CPUs.  This one lock is so bad, it is basically a GIL, and we need t=
o have a serious discussion on how to remove this one lock.
>
> This may sound far fetched, but there is actually some clever cryptograph=
y that can provide a good solution here.    What if the pool was not a line=
ar structure FILO structure, but actually a jump table?  What if access to =
this jump table was randomized, so that no two callers could take the same =
path through the table?  What if in addition, upon read - the reader "cover=
s their tracks" and modifies their entrypoint into the table to prevent any=
 other caller from being able to follow the same path?  This is exactly wha=
t keypoolrandom does.
>
> Now, if the output of this jump table is used as an input to cryptographi=
c primitives such as an ideal block cipher or hash function - then even a s=
ingle bit flip would cause an avalanche which dramatically affects the outp=
ut - and also obscures how it was generated.  Therefore, access using this =
method could never undermine the pool state - therefore this speciture stru=
cture never "drains" but rather becomes less and less predictable over time=
.
>
> This kind of jump table has been written and is called https://github.com=
/TheRook/KeypoolRandom.  This took three years to write, has been peer revi=
ewed and has exquisite documentation, if you take the time to read over thi=
s code and the docs - I think you'll enjoy it.  This project is very easy t=
o compile and to run - it is the software equivalent of a breakout board, a=
nd doesn't require a full kernel compile to see how it functions.
>
> Regards,
> Michael Brooks
>
>
> On Mon, Mar 28, 2022 at 4:20 AM Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: "Jason A. Donenfeld" <Jason@zx2c4.com>
>>
>> [ Upstream commit 6e8ec2552c7d13991148e551e3325a624d73fac6 ]
>>
>> The current 4096-bit LFSR used for entropy collection had a few
>> desirable attributes for the context in which it was created. For
>> example, the state was huge, which meant that /dev/random would be able
>> to output quite a bit of accumulated entropy before blocking. It was
>> also, in its time, quite fast at accumulating entropy byte-by-byte,
>> which matters given the varying contexts in which mix_pool_bytes() is
>> called. And its diffusion was relatively high, which meant that changes
>> would ripple across several words of state rather quickly.
>>
>> However, it also suffers from a few security vulnerabilities. In
>> particular, inputs learned by an attacker can be undone, but moreover,
>> if the state of the pool leaks, its contents can be controlled and
>> entirely zeroed out. I've demonstrated this attack with this SMT2
>> script, <https://xn--4db.cc/5o9xO8pb>, which Boolector/CaDiCal solves in
>> a matter of seconds on a single core of my laptop, resulting in little
>> proof of concept C demonstrators such as <https://xn--4db.cc/jCkvvIaH/c>=
.
>>
>> For basically all recent formal models of RNGs, these attacks represent
>> a significant cryptographic flaw. But how does this manifest
>> practically? If an attacker has access to the system to such a degree
>> that he can learn the internal state of the RNG, arguably there are
>> other lower hanging vulnerabilities -- side-channel, infoleak, or
>> otherwise -- that might have higher priority. On the other hand, seed
>> files are frequently used on systems that have a hard time generating
>> much entropy on their own, and these seed files, being files, often leak
>> or are duplicated and distributed accidentally, or are even seeded over
>> the Internet intentionally, where their contents might be recorded or
>> tampered with. Seen this way, an otherwise quasi-implausible
>> vulnerability is a bit more practical than initially thought.
>>
>> Another aspect of the current mix_pool_bytes() function is that, while
>> its performance was arguably competitive for the time in which it was
>> created, it's no longer considered so. This patch improves performance
>> significantly: on a high-end CPU, an i7-11850H, it improves performance
>> of mix_pool_bytes() by 225%, and on a low-end CPU, a Cortex-A7, it
>> improves performance by 103%.
>>
>> This commit replaces the LFSR of mix_pool_bytes() with a straight-
>> forward cryptographic hash function, BLAKE2s, which is already in use
>> for pool extraction. Universal hashing with a secret seed was considered
>> too, something along the lines of <https://eprint.iacr.org/2013/338>,
>> but the requirement for a secret seed makes for a chicken & egg problem.
>> Instead we go with a formally proven scheme using a computational hash
>> function, described in sections 5.1, 6.4, and B.1.8 of
>> <https://eprint.iacr.org/2019/198>.
>>
>> BLAKE2s outputs 256 bits, which should give us an appropriate amount of
>> min-entropy accumulation, and a wide enough margin of collision
>> resistance against active attacks. mix_pool_bytes() becomes a simple
>> call to blake2s_update(), for accumulation, while the extraction step
>> becomes a blake2s_final() to generate a seed, with which we can then do
>> a HKDF-like or BLAKE2X-like expansion, the first part of which we fold
>> back as an init key for subsequent blake2s_update()s, and the rest we
>> produce to the caller. This then is provided to our CRNG like usual. In
>> that expansion step, we make opportunistic use of 32 bytes of RDRAND
>> output, just as before. We also always reseed the crng with 32 bytes,
>> unconditionally, or not at all, rather than sometimes with 16 as before,
>> as we don't win anything by limiting beyond the 16 byte threshold.
>>
>> Going for a hash function as an entropy collector is a conservative,
>> proven approach. The result of all this is a much simpler and much less
>> bespoke construction than what's there now, which not only plugs a
>> vulnerability but also improves performance considerably.
>>
>> Cc: Theodore Ts'o <tytso@mit.edu>
>> Cc: Dominik Brodowski <linux@dominikbrodowski.net>
>> Reviewed-by: Eric Biggers <ebiggers@google.com>
>> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Reviewed-by: Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
>> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  drivers/char/random.c | 304 ++++++++----------------------------------
>>  1 file changed, 55 insertions(+), 249 deletions(-)
>>
>> diff --git a/drivers/char/random.c b/drivers/char/random.c
>> index 3404a91edf29..882f78829a24 100644
>> --- a/drivers/char/random.c
>> +++ b/drivers/char/random.c
>> @@ -42,61 +42,6 @@
>>   */
>>
>>  /*
>> - * (now, with legal B.S. out of the way.....)
>> - *
>> - * This routine gathers environmental noise from device drivers, etc.,
>> - * and returns good random numbers, suitable for cryptographic use.
>> - * Besides the obvious cryptographic uses, these numbers are also good
>> - * for seeding TCP sequence numbers, and other places where it is
>> - * desirable to have numbers which are not only random, but hard to
>> - * predict by an attacker.
>> - *
>> - * Theory of operation
>> - * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> - *
>> - * Computers are very predictable devices.  Hence it is extremely hard
>> - * to produce truly random numbers on a computer --- as opposed to
>> - * pseudo-random numbers, which can easily generated by using a
>> - * algorithm.  Unfortunately, it is very easy for attackers to guess
>> - * the sequence of pseudo-random number generators, and for some
>> - * applications this is not acceptable.  So instead, we must try to
>> - * gather "environmental noise" from the computer's environment, which
>> - * must be hard for outside attackers to observe, and use that to
>> - * generate random numbers.  In a Unix environment, this is best done
>> - * from inside the kernel.
>> - *
>> - * Sources of randomness from the environment include inter-keyboard
>> - * timings, inter-interrupt timings from some interrupts, and other
>> - * events which are both (a) non-deterministic and (b) hard for an
>> - * outside observer to measure.  Randomness from these sources are
>> - * added to an "entropy pool", which is mixed using a CRC-like function=
.
>> - * This is not cryptographically strong, but it is adequate assuming
>> - * the randomness is not chosen maliciously, and it is fast enough that
>> - * the overhead of doing it on every interrupt is very reasonable.
>> - * As random bytes are mixed into the entropy pool, the routines keep
>> - * an *estimate* of how many bits of randomness have been stored into
>> - * the random number generator's internal state.
>> - *
>> - * When random bytes are desired, they are obtained by taking the BLAKE=
2s
>> - * hash of the contents of the "entropy pool".  The BLAKE2s hash avoids
>> - * exposing the internal state of the entropy pool.  It is believed to
>> - * be computationally infeasible to derive any useful information
>> - * about the input of BLAKE2s from its output.  Even if it is possible =
to
>> - * analyze BLAKE2s in some clever way, as long as the amount of data
>> - * returned from the generator is less than the inherent entropy in
>> - * the pool, the output data is totally unpredictable.  For this
>> - * reason, the routine decreases its internal estimate of how many
>> - * bits of "true randomness" are contained in the entropy pool as it
>> - * outputs random numbers.
>> - *
>> - * If this estimate goes to zero, the routine can still generate
>> - * random numbers; however, an attacker may (at least in theory) be
>> - * able to infer the future output of the generator from prior
>> - * outputs.  This requires successful cryptanalysis of BLAKE2s, which i=
s
>> - * not believed to be feasible, but there is a remote possibility.
>> - * Nonetheless, these numbers should be useful for the vast majority
>> - * of purposes.
>> - *
>>   * Exported interfaces ---- output
>>   * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>   *
>> @@ -298,23 +243,6 @@
>>   *
>>   *     mknod /dev/random c 1 8
>>   *     mknod /dev/urandom c 1 9
>> - *
>> - * Acknowledgements:
>> - * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> - *
>> - * Ideas for constructing this random number generator were derived
>> - * from Pretty Good Privacy's random number generator, and from private
>> - * discussions with Phil Karn.  Colin Plumb provided a faster random
>> - * number generator, which speed up the mixing function of the entropy
>> - * pool, taken from PGPfone.  Dale Worley has also contributed many
>> - * useful ideas and suggestions to improve this driver.
>> - *
>> - * Any flaws in the design are solely my responsibility, and should
>> - * not be attributed to the Phil, Colin, or any of authors of PGP.
>> - *
>> - * Further background information on this topic may be obtained from
>> - * RFC 1750, "Randomness Recommendations for Security", by Donald
>> - * Eastlake, Steve Crocker, and Jeff Schiller.
>>   */
>>
>>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>> @@ -358,79 +286,15 @@
>>
>>  /* #define ADD_INTERRUPT_BENCH */
>>
>> -/*
>> - * If the entropy count falls under this number of bits, then we
>> - * should wake up processes which are selecting or polling on write
>> - * access to /dev/random.
>> - */
>> -static int random_write_wakeup_bits =3D 28 * (1 << 5);
>> -
>> -/*
>> - * Originally, we used a primitive polynomial of degree .poolwords
>> - * over GF(2).  The taps for various sizes are defined below.  They
>> - * were chosen to be evenly spaced except for the last tap, which is 1
>> - * to get the twisting happening as fast as possible.
>> - *
>> - * For the purposes of better mixing, we use the CRC-32 polynomial as
>> - * well to make a (modified) twisted Generalized Feedback Shift
>> - * Register.  (See M. Matsumoto & Y. Kurita, 1992.  Twisted GFSR
>> - * generators.  ACM Transactions on Modeling and Computer Simulation
>> - * 2(3):179-194.  Also see M. Matsumoto & Y. Kurita, 1994.  Twisted
>> - * GFSR generators II.  ACM Transactions on Modeling and Computer
>> - * Simulation 4:254-266)
>> - *
>> - * Thanks to Colin Plumb for suggesting this.
>> - *
>> - * The mixing operation is much less sensitive than the output hash,
>> - * where we use BLAKE2s.  All that we want of mixing operation is that
>> - * it be a good non-cryptographic hash; i.e. it not produce collisions
>> - * when fed "random" data of the sort we expect to see.  As long as
>> - * the pool state differs for different inputs, we have preserved the
>> - * input entropy and done a good job.  The fact that an intelligent
>> - * attacker can construct inputs that will produce controlled
>> - * alterations to the pool's state is not important because we don't
>> - * consider such inputs to contribute any randomness.  The only
>> - * property we need with respect to them is that the attacker can't
>> - * increase his/her knowledge of the pool's state.  Since all
>> - * additions are reversible (knowing the final state and the input,
>> - * you can reconstruct the initial state), if an attacker has any
>> - * uncertainty about the initial state, he/she can only shuffle that
>> - * uncertainty about, but never cause any collisions (which would
>> - * decrease the uncertainty).
>> - *
>> - * Our mixing functions were analyzed by Lacharme, Roeck, Strubel, and
>> - * Videau in their paper, "The Linux Pseudorandom Number Generator
>> - * Revisited" (see: http://eprint.iacr.org/2012/251.pdf).  In their
>> - * paper, they point out that we are not using a true Twisted GFSR,
>> - * since Matsumoto & Kurita used a trinomial feedback polynomial (that
>> - * is, with only three taps, instead of the six that we are using).
>> - * As a result, the resulting polynomial is neither primitive nor
>> - * irreducible, and hence does not have a maximal period over
>> - * GF(2**32).  They suggest a slight change to the generator
>> - * polynomial which improves the resulting TGFSR polynomial to be
>> - * irreducible, which we have made here.
>> - */
>>  enum poolinfo {
>> -       POOL_WORDS =3D 128,
>> -       POOL_WORDMASK =3D POOL_WORDS - 1,
>> -       POOL_BYTES =3D POOL_WORDS * sizeof(u32),
>> -       POOL_BITS =3D POOL_BYTES * 8,
>> +       POOL_BITS =3D BLAKE2S_HASH_SIZE * 8,
>>         POOL_BITSHIFT =3D ilog2(POOL_BITS),
>>
>>         /* To allow fractional bits to be tracked, the entropy_count fie=
ld is
>>          * denominated in units of 1/8th bits. */
>>         POOL_ENTROPY_SHIFT =3D 3,
>>  #define POOL_ENTROPY_BITS() (input_pool.entropy_count >> POOL_ENTROPY_S=
HIFT)
>> -       POOL_FRACBITS =3D POOL_BITS << POOL_ENTROPY_SHIFT,
>> -
>> -       /* x^128 + x^104 + x^76 + x^51 +x^25 + x + 1 */
>> -       POOL_TAP1 =3D 104,
>> -       POOL_TAP2 =3D 76,
>> -       POOL_TAP3 =3D 51,
>> -       POOL_TAP4 =3D 25,
>> -       POOL_TAP5 =3D 1,
>> -
>> -       EXTRACT_SIZE =3D BLAKE2S_HASH_SIZE / 2
>> +       POOL_FRACBITS =3D POOL_BITS << POOL_ENTROPY_SHIFT
>>  };
>>
>>  /*
>> @@ -438,6 +302,12 @@ enum poolinfo {
>>   */
>>  static DECLARE_WAIT_QUEUE_HEAD(random_write_wait);
>>  static struct fasync_struct *fasync;
>> +/*
>> + * If the entropy count falls under this number of bits, then we
>> + * should wake up processes which are selecting or polling on write
>> + * access to /dev/random.
>> + */
>> +static int random_write_wakeup_bits =3D POOL_BITS * 3 / 4;
>>
>>  static DEFINE_SPINLOCK(random_ready_list_lock);
>>  static LIST_HEAD(random_ready_list);
>> @@ -493,73 +363,31 @@ MODULE_PARM_DESC(ratelimit_disable, "Disable rando=
m ratelimit suppression");
>>   *
>>   **********************************************************************=
/
>>
>> -static u32 input_pool_data[POOL_WORDS] __latent_entropy;
>> -
>>  static struct {
>> +       struct blake2s_state hash;
>>         spinlock_t lock;
>> -       u16 add_ptr;
>> -       u16 input_rotate;
>>         int entropy_count;
>>  } input_pool =3D {
>> +       .hash.h =3D { BLAKE2S_IV0 ^ (0x01010000 | BLAKE2S_HASH_SIZE),
>> +                   BLAKE2S_IV1, BLAKE2S_IV2, BLAKE2S_IV3, BLAKE2S_IV4,
>> +                   BLAKE2S_IV5, BLAKE2S_IV6, BLAKE2S_IV7 },
>> +       .hash.outlen =3D BLAKE2S_HASH_SIZE,
>>         .lock =3D __SPIN_LOCK_UNLOCKED(input_pool.lock),
>>  };
>>
>> -static ssize_t extract_entropy(void *buf, size_t nbytes, int min);
>> -static ssize_t _extract_entropy(void *buf, size_t nbytes);
>> +static bool extract_entropy(void *buf, size_t nbytes, int min);
>> +static void _extract_entropy(void *buf, size_t nbytes);
>>
>>  static void crng_reseed(struct crng_state *crng, bool use_input_pool);
>>
>> -static const u32 twist_table[8] =3D {
>> -       0x00000000, 0x3b6e20c8, 0x76dc4190, 0x4db26158,
>> -       0xedb88320, 0xd6d6a3e8, 0x9b64c2b0, 0xa00ae278 };
>> -
>>  /*
>>   * This function adds bytes into the entropy "pool".  It does not
>>   * update the entropy estimate.  The caller should call
>>   * credit_entropy_bits if this is appropriate.
>> - *
>> - * The pool is stirred with a primitive polynomial of the appropriate
>> - * degree, and then twisted.  We twist by three bits at a time because
>> - * it's cheap to do so and helps slightly in the expected case where
>> - * the entropy is concentrated in the low-order bits.
>>   */
>>  static void _mix_pool_bytes(const void *in, int nbytes)
>>  {
>> -       unsigned long i;
>> -       int input_rotate;
>> -       const u8 *bytes =3D in;
>> -       u32 w;
>> -
>> -       input_rotate =3D input_pool.input_rotate;
>> -       i =3D input_pool.add_ptr;
>> -
>> -       /* mix one byte at a time to simplify size handling and churn fa=
ster */
>> -       while (nbytes--) {
>> -               w =3D rol32(*bytes++, input_rotate);
>> -               i =3D (i - 1) & POOL_WORDMASK;
>> -
>> -               /* XOR in the various taps */
>> -               w ^=3D input_pool_data[i];
>> -               w ^=3D input_pool_data[(i + POOL_TAP1) & POOL_WORDMASK];
>> -               w ^=3D input_pool_data[(i + POOL_TAP2) & POOL_WORDMASK];
>> -               w ^=3D input_pool_data[(i + POOL_TAP3) & POOL_WORDMASK];
>> -               w ^=3D input_pool_data[(i + POOL_TAP4) & POOL_WORDMASK];
>> -               w ^=3D input_pool_data[(i + POOL_TAP5) & POOL_WORDMASK];
>> -
>> -               /* Mix the result back in with a twist */
>> -               input_pool_data[i] =3D (w >> 3) ^ twist_table[w & 7];
>> -
>> -               /*
>> -                * Normally, we add 7 bits of rotation to the pool.
>> -                * At the beginning of the pool, add an extra 7 bits
>> -                * rotation, so that successive passes spread the
>> -                * input bits across the pool evenly.
>> -                */
>> -               input_rotate =3D (input_rotate + (i ? 7 : 14)) & 31;
>> -       }
>> -
>> -       input_pool.input_rotate =3D input_rotate;
>> -       input_pool.add_ptr =3D i;
>> +       blake2s_update(&input_pool.hash, in, nbytes);
>>  }
>>
>>  static void __mix_pool_bytes(const void *in, int nbytes)
>> @@ -953,15 +781,14 @@ static int crng_slow_load(const u8 *cp, size_t len=
)
>>  static void crng_reseed(struct crng_state *crng, bool use_input_pool)
>>  {
>>         unsigned long flags;
>> -       int i, num;
>> +       int i;
>>         union {
>>                 u8 block[CHACHA_BLOCK_SIZE];
>>                 u32 key[8];
>>         } buf;
>>
>>         if (use_input_pool) {
>> -               num =3D extract_entropy(&buf, 32, 16);
>> -               if (num =3D=3D 0)
>> +               if (!extract_entropy(&buf, 32, 16))
>>                         return;
>>         } else {
>>                 _extract_crng(&primary_crng, buf.block);
>> @@ -1329,74 +1156,48 @@ static size_t account(size_t nbytes, int min)
>>  }
>>
>>  /*
>> - * This function does the actual extraction for extract_entropy.
>> - *
>> - * Note: we assume that .poolwords is a multiple of 16 words.
>> + * This is an HKDF-like construction for using the hashed collected ent=
ropy
>> + * as a PRF key, that's then expanded block-by-block.
>>   */
>> -static void extract_buf(u8 *out)
>> +static void _extract_entropy(void *buf, size_t nbytes)
>>  {
>> -       struct blake2s_state state __aligned(__alignof__(unsigned long))=
;
>> -       u8 hash[BLAKE2S_HASH_SIZE];
>> -       unsigned long *salt;
>>         unsigned long flags;
>> -
>> -       blake2s_init(&state, sizeof(hash));
>> -
>> -       /*
>> -        * If we have an architectural hardware random number
>> -        * generator, use it for BLAKE2's salt & personal fields.
>> -        */
>> -       for (salt =3D (unsigned long *)&state.h[4];
>> -            salt < (unsigned long *)&state.h[8]; ++salt) {
>> -               unsigned long v;
>> -               if (!arch_get_random_long(&v))
>> -                       break;
>> -               *salt ^=3D v;
>> +       u8 seed[BLAKE2S_HASH_SIZE], next_key[BLAKE2S_HASH_SIZE];
>> +       struct {
>> +               unsigned long rdrand[32 / sizeof(long)];
>> +               size_t counter;
>> +       } block;
>> +       size_t i;
>> +
>> +       for (i =3D 0; i < ARRAY_SIZE(block.rdrand); ++i) {
>> +               if (!arch_get_random_long(&block.rdrand[i]))
>> +                       block.rdrand[i] =3D random_get_entropy();
>>         }
>>
>> -       /* Generate a hash across the pool */
>>         spin_lock_irqsave(&input_pool.lock, flags);
>> -       blake2s_update(&state, (const u8 *)input_pool_data, POOL_BYTES);
>> -       blake2s_final(&state, hash); /* final zeros out state */
>>
>> -       /*
>> -        * We mix the hash back into the pool to prevent backtracking
>> -        * attacks (where the attacker knows the state of the pool
>> -        * plus the current outputs, and attempts to find previous
>> -        * outputs), unless the hash function can be inverted. By
>> -        * mixing at least a hash worth of hash data back, we make
>> -        * brute-forcing the feedback as hard as brute-forcing the
>> -        * hash.
>> -        */
>> -       __mix_pool_bytes(hash, sizeof(hash));
>> -       spin_unlock_irqrestore(&input_pool.lock, flags);
>> +       /* seed =3D HASHPRF(last_key, entropy_input) */
>> +       blake2s_final(&input_pool.hash, seed);
>>
>> -       /* Note that EXTRACT_SIZE is half of hash size here, because abo=
ve
>> -        * we've dumped the full length back into mixer. By reducing the
>> -        * amount that we emit, we retain a level of forward secrecy.
>> -        */
>> -       memcpy(out, hash, EXTRACT_SIZE);
>> -       memzero_explicit(hash, sizeof(hash));
>> -}
>> +       /* next_key =3D HASHPRF(seed, RDRAND || 0) */
>> +       block.counter =3D 0;
>> +       blake2s(next_key, (u8 *)&block, seed, sizeof(next_key), sizeof(b=
lock), sizeof(seed));
>> +       blake2s_init_key(&input_pool.hash, BLAKE2S_HASH_SIZE, next_key, =
sizeof(next_key));
>>
>> -static ssize_t _extract_entropy(void *buf, size_t nbytes)
>> -{
>> -       ssize_t ret =3D 0, i;
>> -       u8 tmp[EXTRACT_SIZE];
>> +       spin_unlock_irqrestore(&input_pool.lock, flags);
>> +       memzero_explicit(next_key, sizeof(next_key));
>>
>>         while (nbytes) {
>> -               extract_buf(tmp);
>> -               i =3D min_t(int, nbytes, EXTRACT_SIZE);
>> -               memcpy(buf, tmp, i);
>> +               i =3D min_t(size_t, nbytes, BLAKE2S_HASH_SIZE);
>> +               /* output =3D HASHPRF(seed, RDRAND || ++counter) */
>> +               ++block.counter;
>> +               blake2s(buf, (u8 *)&block, seed, i, sizeof(block), sizeo=
f(seed));
>>                 nbytes -=3D i;
>>                 buf +=3D i;
>> -               ret +=3D i;
>>         }
>>
>> -       /* Wipe data just returned from memory */
>> -       memzero_explicit(tmp, sizeof(tmp));
>> -
>> -       return ret;
>> +       memzero_explicit(seed, sizeof(seed));
>> +       memzero_explicit(&block, sizeof(block));
>>  }
>>
>>  /*
>> @@ -1404,13 +1205,18 @@ static ssize_t _extract_entropy(void *buf, size_=
t nbytes)
>>   * returns it in a buffer.
>>   *
>>   * The min parameter specifies the minimum amount we can pull before
>> - * failing to avoid races that defeat catastrophic reseeding.
>> + * failing to avoid races that defeat catastrophic reseeding. If we
>> + * have less than min entropy available, we return false and buf is
>> + * not filled.
>>   */
>> -static ssize_t extract_entropy(void *buf, size_t nbytes, int min)
>> +static bool extract_entropy(void *buf, size_t nbytes, int min)
>>  {
>>         trace_extract_entropy(nbytes, POOL_ENTROPY_BITS(), _RET_IP_);
>> -       nbytes =3D account(nbytes, min);
>> -       return _extract_entropy(buf, nbytes);
>> +       if (account(nbytes, min)) {
>> +               _extract_entropy(buf, nbytes);
>> +               return true;
>> +       }
>> +       return false;
>>  }
>>
>>  #define warn_unseeded_randomness(previous) \
>> @@ -1674,7 +1480,7 @@ static void __init init_std_data(void)
>>         unsigned long rv;
>>
>>         mix_pool_bytes(&now, sizeof(now));
>> -       for (i =3D POOL_BYTES; i > 0; i -=3D sizeof(rv)) {
>> +       for (i =3D BLAKE2S_BLOCK_SIZE; i > 0; i -=3D sizeof(rv)) {
>>                 if (!arch_get_random_seed_long(&rv) &&
>>                     !arch_get_random_long(&rv))
>>                         rv =3D random_get_entropy();
>> --
>> 2.34.1
>>
